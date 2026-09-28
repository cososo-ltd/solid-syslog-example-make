# solid-syslog-example

A worked integration of [SolidSyslog](https://github.com/cososo-ltd/solid-syslog), built up in
stages — from a device with no syslog at all to one whose records are authenticated and encrypted.

Each stage is one commit. It says what it does, what it changes, what it gives you, and what it
costs. The costs are measured by the device itself, not estimated.

It builds on a baseline that simulates the sort of device you might be adding this to, and that
measures itself: see [docs/baseline.md](docs/baseline.md) for what the baseline is, how the
figures are made, and how to run it.

## This stage — Linked

SolidSyslog is linked into the application without any of it being called. The stage is broken out
for clarity: it separates getting the build to accept the library from getting the device to use
it, so anything that goes wrong here is a build problem and nothing else.

The library ships `solidsyslog.mk`, so `make/solidsyslog.mk` fetches the library, names the
platforms and includes it, and gets the source lists and include sets back.
`SOLIDSYSLOG_PLATFORMS` names the platforms rather than letting the library infer them from the
environment — lwIP alone, because nothing at this stage reaches any other pack. What is left is this
build's own architecture: Core compiles against the library's own headers into an archive, and the
platform sources compile with this device's flags and config headers.

`--gc-sections` discards what nothing calls, so a platform pack that is linked but unused does not
reach the image.

For now you need only the core and a network platform. The pin is the SHA in `solid-syslog.pin`,
which the build reads, and a change to that file fetches the commit it names.

## License

This example's own code is [0BSD](LICENSE) — completely open, no conditions.

Third-party code keeps its own license: the vendored Arm SMSC9220 driver (`app/net/smsc9220/`) is
Apache-2.0 (see its `LICENSE`). FreeRTOS, lwIP, mbedTLS and FatFs are under `third_party/` and used
under their own upstream licenses — [`third_party/README.md`](third_party/README.md) says which,
and how each is pinned or vendored.

SolidSyslog is fetched at build time and is likewise not redistributed here. It is offered under
three alternative licenses, which its own
[LICENSE.md](https://github.com/cososo-ltd/solid-syslog/blob/main/LICENSE.md) sets out.
