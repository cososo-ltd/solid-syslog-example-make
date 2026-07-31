# solid-syslog-example — run (aes-gcm)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,363248,349808,13440
[report] flash_data,656,316,340
[report] static_bss,148284,110876,37408
[report] heap_used,4440,4440,0
[report] mbedtls_peak,37252,21328,15924
[report] mbedtls_free,19068,11440,7628
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,13,13,0
[report] stack_log,832,120,712
[report] stack_service,3852,52,3800
[report] stack_harness,2848,2840,8
[report] --- end ---
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 363240	    664	 148284	 512188	  7d0bc	/w/build/baseline.elf
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
wire   <134>1 2026-08-01T08:04:09.370000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="1" sysUpTime="237"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.1.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="aes-256-gcm"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-08-01T08:04:09+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="1" sysUpTime="237"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.1.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="aes-256-gcm"] MSG=device started
```

## Self-check (vs measurements/aes-gcm.csv)

```text
  OK    flash_text: 363248 (expected 363248, Δ0)
  OK    flash_data: 656 (expected 656, Δ0)
  OK    static_bss: 148284 (expected 148284, Δ0)
  OK    heap_used: 4440 (expected 4440, Δ0)
  OK    mbedtls_peak: 37252 (expected 37252, Δ0)
  OK    mbedtls_free: 19068 (expected 19068, Δ0)
  OK    lwip_mem_free: 7576 (expected 7576, Δ0)
  OK    lwip_pbufs_free: 13 (expected 13, Δ0)
  OK    stack_log: 832 (expected 832, Δ0)
  OK    stack_service: 3852 (expected 3852, Δ0)
  OK    stack_harness: 2848 (expected 2848, Δ0)
```

**RESULT: PASS**
