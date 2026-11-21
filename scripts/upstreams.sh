#!/usr/bin/env bash
# Move this stack's own upstreams to the ones a cross image carries.
#
#   scripts/upstreams.sh <image> <tree>
#
# The CMake build of this example takes FreeRTOS-Kernel, lwIP, Mbed TLS and FatFs
# from the image; this one carries them under third_party/, and the two are only
# comparable while they are the same sources. <tree> is a checkout of the Baseline,
# and is left with, staged:
#
#   FreeRTOS-Kernel, lwip   the submodules at the image's commits
#   fatfs                   the image's source/, LICENSE.txt and README.asc
#   mbedtls                 the paths third_party/mbedtls.keep lists, from the
#                           release tarball of the image's tag
#   upstream.pins           what each of them now is
#
# Mbed TLS comes from the tarball because a release ships sources a checkout has
# to generate. The image's checkout is what vouches for it: every kept file the
# checkout also holds must match it byte for byte, or nothing is changed.
set -euo pipefail

IMAGE="${1:?usage: scripts/upstreams.sh <image> <tree>}"
TREE="$(cd "${2:?usage: scripts/upstreams.sh <image> <tree>}" && pwd)"
THIRD="$TREE/third_party"
PINS="$THIRD/upstream.pins"
KEEP="$THIRD/mbedtls.keep"

fail() { echo "upstreams: $*" >&2; exit 1; }
note() { echo "upstreams: $*" >&2; }
# Reads the image's trees as root, whoever owns them, and writes nothing there.
image() { docker run --rm "$IMAGE" "$@"; }
pinned() { awk -v name="$1" -v field="$2" '$1 == name { print $field }' "$PINS" 2>/dev/null || true; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# name, tag, commit: one line per tree.
image bash -c '
    for tree in FreeRTOS-Kernel:$FREERTOS_KERNEL_PATH lwip:$LWIP_PATH mbedtls:$MBEDTLS_DIR fatfs:$FATFS_PATH; do
        dir=${tree#*:}
        echo "${tree%%:*} $(git -C "$dir" describe --tags --exact-match) $(git -C "$dir" rev-parse HEAD)"
    done' > "$WORK/carried"
[ "$(wc -l < "$WORK/carried")" -eq 4 ] || fail "the image does not name all four trees"
carried() { awk -v name="$1" -v field="$2" '$1 == name { print $field }' "$WORK/carried"; }

# ---- the submodules ----------------------------------------------------------
for name in FreeRTOS-Kernel lwip; do
    git -C "$TREE" update-index --cacheinfo "160000,$(carried "$name" 3),third_party/$name"
done

# ---- FatFs -------------------------------------------------------------------
rm -rf "$THIRD/fatfs" && mkdir "$THIRD/fatfs"
image bash -c 'git -C "$FATFS_PATH" archive HEAD source LICENSE.txt README.asc' | tar -x -C "$THIRD/fatfs"

# ---- Mbed TLS ----------------------------------------------------------------
# The first move finds no list, and keeps what the tree already keeps.
[ -f "$KEEP" ] || ls -A "$THIRD/mbedtls" > "$KEEP"
mapfile -t keep < <(grep -v '^[[:space:]]*\(#\|$\)' "$KEEP")
[ "${#keep[@]}" -gt 0 ] || fail "$KEEP lists nothing"
tag="$(carried mbedtls 2)"
version="${tag#mbedtls-}" && version="${version#v}"
tarball_sha="$(pinned mbedtls 4)"

vendor() {
    local url="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-$version/mbedtls-$version.tar.bz2"
    note "vendoring Mbed TLS $version from $url"
    curl -fsSL -o "$WORK/mbedtls.tar.bz2" "$url" || fail "cannot fetch $url"
    tarball_sha="$(sha256sum "$WORK/mbedtls.tar.bz2" | cut -d' ' -f1)"
    rm -rf "$WORK/release" && mkdir "$WORK/release"
    tar -xj -C "$WORK/release" --strip-components=1 -f "$WORK/mbedtls.tar.bz2" "${keep[@]/#/mbedtls-$version/}"
    rm -rf "$THIRD/mbedtls" && mv "$WORK/release" "$THIRD/mbedtls"
}

# The checkout keeps framework/ as a submodule, so its files are archived apart.
mkdir "$WORK/checkout"
image bash -c '
    cd "$MBEDTLS_DIR"
    for path in "$@"; do
        case "$path" in
            framework/*) git -C framework archive --prefix=framework/ HEAD "${path#framework/}" | tar -x -C /tmp ;;
            framework)   git -C framework archive --prefix=framework/ HEAD | tar -x -C /tmp ;;
            *)           git archive HEAD "$path" | tar -x -C /tmp ;;
        esac
    done
    cd /tmp && tar -c "$@"' _ "${keep[@]}" | tar -x -C "$WORK/checkout"
differing() {
    (cd "$WORK/checkout" && find . -type f | while read -r file; do
        cmp -s "$file" "$THIRD/mbedtls/$file" || echo "${file#./}"
    done)
}

# Vendored again when the image moved to another release, and when the tree is
# not what the list asks for, which is how a path added to the list arrives.
if [ "$(pinned mbedtls 2)" != "$tag" ] || [ -z "$tarball_sha" ] || [ -n "$(differing)" ]; then
    vendor
fi
wrong="$(differing)"
[ -z "$wrong" ] || fail "Mbed TLS under third_party/ is not the image's $tag: $(echo "$wrong" | head -5 | tr '\n' ' ')"

# ---- what they are now -------------------------------------------------------
{
    echo "# The upstreams under third_party/, as the cross image carries them: name, tag,"
    echo "# commit, and for Mbed TLS the sha256 of its release tarball. Written by"
    echo "# scripts/upstreams.sh; third_party/README.md says what each one is."
    awk -v sha="$tarball_sha" '{ print $1, $2, $3 ($1 == "mbedtls" ? " " sha : "") }' "$WORK/carried"
} > "$PINS"

git -C "$TREE" add -A third_party
note "$(grep -v '^#' "$PINS" | awk '{ printf "%s%s %s", (n++ ? ", " : ""), $1, $2 }')"
