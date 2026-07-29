# Upstream dependencies

Four upstream projects, none of them modified. Each is consumed the way it publishes itself, which
is why two are submodules and two are vendored — the mechanism follows the project, not a house
rule.

| | Version | How | Pin |
|---|---|---|---|
| `FreeRTOS-Kernel` | V11.1.0 | submodule | `dbf70559b27d39c1fdb68dfb9a32140b6a6777a0` |
| `lwip` | STABLE-2_2_1_RELEASE | submodule | `77dcd25a72509eb83f72b033d219b1d40cd8eb95` |
| `mbedtls` | 3.6.2 | vendored release | `mbedtls-3.6.2.tar.bz2`, sha256 `8b54fb9b…5ccbdca` |
| `fatfs` | R0.16 patch 1 | vendored source | see below |

Clone with `--recurse-submodules`, or run `git submodule update --init --recursive`. mbedTLS and
FatFs need neither — they are in the tree.

## The two submodules

FreeRTOS-Kernel and lwIP both publish a git repository with release tags, so a submodule pins them
exactly and an upgrade is a one-line SHA change. lwIP also ships `src/Filelists.mk`, which
`make/lwip.mk` includes rather than re-typing its source list.

## mbedTLS — vendored from the release tarball, not from git

`https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.2/mbedtls-3.6.2.tar.bz2`

    sha256  8b54fb9bcf4d5a7078028e0520acddefb7900b3e66fec7f7175bb5b7d85ccdca

**The release is the supported artefact and a git checkout is not.** mbedTLS generates five of its
own sources — `error.c`, `version_features.c`, `ssl_debug_helpers_generated.c` and the two
`psa_crypto_driver_wrappers` files — and ships them in releases but not in the repository. Building
from a checkout means running the generators, which need Perl, Python, and Python packages that a
cross-build image has no other reason to carry.

`library/`, `include/`, `3rdparty/`, `Makefile`, `LICENSE`, `README.md` and `ChangeLog` are taken
verbatim. `tests/`, `programs/`, `framework/`, `scripts/`, `docs/` and the CMake and Visual Studio
files are not: 34 MB this device never compiles. The generated sources are present, so
`make -C third_party/mbedtls lib` never invokes a generator — their prerequisites are order-only
and the files exist.

## FatFs — vendored source

FatFs has no upstream git repository; ChaN publishes it as a zip from
<http://elm-chan.org/fsw/ff/00index_e.html>. `source/`, `LICENSE.txt` and `README.asc` here are
R0.16 patch 1, taken from the `github.com/abbrev/fatfs` mirror at
`30ca13c62615df0d2e9104ab41256985b96590c1` — the same bytes the cross container carries, which is
what keeps this image comparable with the CMake build of this example.

    sha256  dbeae3d7d22dbc070983e31af897fa5e43d29c726a0a240fe9589ffe2ec0ef1e  source/ff.c
            42920ae4d6080bfc2a72d92a9969b5e94eeaff070e5e71d90da9ab6d7d8e158e  source/ff.h
            1c2b29f53e061c55d43b2e412c3a61320b2621bac7561a05e275514baa44785a  source/diskio.h

Only `ff.c` is compiled, and `ff.h`/`diskio.h` are staged into `build/fatfs` beside this example's
own `ffconf.h`. `source/ffconf.h`, `source/ffsystem.c`, `source/diskio.c` and `source/ffunicode.c`
are upstream's, kept for provenance and not built: this example supplies its own.

## Licences

All four are permissive and are used unmodified with their notices intact: FreeRTOS-Kernel MIT,
lwIP BSD-3-Clause, mbedTLS Apache-2.0, FatFs 1-clause BSD. Each project's own licence file is in
its directory.
