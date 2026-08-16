# solid-syslog-example — run (time-quality)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,357272,349808,7464
[report] flash_data,496,316,180
[report] static_bss,118384,110876,7508
[report] heap_used,4440,4440,0
[report] mbedtls_peak,21344,21328,16
[report] mbedtls_free,11424,11440,-16
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,13,13,0
[report] stack_log,792,120,672
[report] stack_service,948,52,896
[report] stack_harness,2848,2840,8
[report] --- end ---
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 357264	    504	 118384	 476152	  743f8	/w/build/baseline.elf
```

## Listeners (proved before the device ran)

```text
  OK    udp    5514
  OK    tcp    5601
  OK    tls    6514
  OK    mtls   6515
  OK    mtls   6515 — refused a client with no certificate
  OK    broker 8883
  OK    broker 8883 — refused a client with no certificate
```

## Collector (syslog-ng) received

```text
wire   <134>1 2026-08-16T19:33:31.370000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="1" sysUpTime="237"][timeQuality tzKnown="1" isSynced="0"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-08-16T19:33:31+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="1" sysUpTime="237"][timeQuality tzKnown="1" isSynced="0"] MSG=device started
```

## Self-check (vs measurements/time-quality.csv)

```text
  OK    flash_text: 357272 (expected 357272, Δ0)
  OK    flash_data: 496 (expected 496, Δ0)
  OK    static_bss: 118384 (expected 118384, Δ0)
  OK    heap_used: 4440 (expected 4440, Δ0)
  OK    mbedtls_peak: 21344 (expected 21316, Δ28)
  OK    mbedtls_free: 11424 (expected 11452, Δ28)
  OK    lwip_mem_free: 7576 (expected 7576, Δ0)
  OK    lwip_pbufs_free: 13 (expected 14, Δ1)
  OK    stack_log: 792 (expected 792, Δ0)
  OK    stack_service: 948 (expected 948, Δ0)
  OK    stack_harness: 2848 (expected 2848, Δ0)
```

**RESULT: PASS**
