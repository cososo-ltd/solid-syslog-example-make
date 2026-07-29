# Upstream dependencies

Four upstream projects, none of them modified. Each is consumed the way it publishes itself, which
is why two are submodules and two are vendored — the mechanism follows the project, not a house
rule.

| | How |
|---|---|
| `FreeRTOS-Kernel` | submodule |
| `lwip` | submodule |
| `mbedtls` | vendored release |
| `fatfs` | vendored source |

[`upstream.pins`](upstream.pins) names the tag and the commit each one is at, and for mbedTLS the
sha256 of its release tarball. They are the versions the cross container carries, which is what
keeps this image comparable with the CMake build of this example.

Clone with `--recurse-submodules`, or run `git submodule update --init --recursive`. mbedTLS and
FatFs need neither — they are in the tree.

## The two submodules

FreeRTOS-Kernel and lwIP both publish a git repository with release tags, so a submodule pins them
exactly and an upgrade is a one-line SHA change. lwIP also ships `src/Filelists.mk`, which
`make/lwip.mk` includes rather than re-typing its source list.

## mbedTLS — vendored from the release tarball, not from git

The tarball is the one mbedTLS publishes on its releases page for the tag `upstream.pins` names.

**The release is the supported artefact and a git checkout is not.** mbedTLS generates five of its
own sources — `error.c`, `version_features.c`, `ssl_debug_helpers_generated.c` and the two
`psa_crypto_driver_wrappers` files — and ships them in releases but not in the repository. Building
from a checkout means running the generators, which need Perl, Python, and Python packages that a
cross-build image has no other reason to carry.

The paths [`mbedtls.keep`](mbedtls.keep) lists are taken verbatim: `library/`, `include/`,
`3rdparty/`, `scripts/`, `Makefile`, `LICENSE`, `README.md`, `ChangeLog` and one file of
`framework/`. `tests/`, `programs/`, the rest of `framework/`, `docs/` and the CMake and Visual
Studio files are not, and they are most of the release. The generated sources are present, so
`make -C third_party/mbedtls lib` never invokes a generator — their prerequisites are order-only
and the files exist. The file kept from `framework/` is one of those prerequisites: the script that
would generate `ssl_debug_helpers_generated.c`, which make needs to find and never runs.

## FatFs — vendored source

FatFs has no upstream git repository; ChaN publishes it as a zip from
<http://elm-chan.org/fsw/ff/00index_e.html>. `source/`, `LICENSE.txt` and `README.asc` here are
taken from the `github.com/abbrev/fatfs` mirror, at the commit `upstream.pins` names.

Only `ff.c` is compiled, and `ff.h`/`diskio.h` are staged into `build/fatfs` beside this example's
own `ffconf.h`. `source/ffconf.h`, `source/ffsystem.c`, `source/diskio.c` and `source/ffunicode.c`
are upstream's, kept for provenance and not built: this example supplies its own.

## Licences

All four are permissive and are used unmodified with their notices intact: FreeRTOS-Kernel MIT,
lwIP BSD-3-Clause, mbedTLS Apache-2.0, FatFs 1-clause BSD. Each project's own licence file is in
its directory.
