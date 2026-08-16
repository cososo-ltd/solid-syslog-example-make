# solid-syslog-example — run (hmac)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,362912,349808,13104
[report] flash_data,644,316,328
[report] static_bss,148016,110876,37140
[report] heap_used,4440,4440,0
[report] mbedtls_peak,36064,21328,14736
[report] mbedtls_free,18208,11440,6768
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,13,13,0
[report] stack_log,800,120,680
[report] stack_service,3820,52,3768
[report] stack_harness,2848,2840,8
[report] --- end ---
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 362904	    652	 148016	 511572	  7ce54	/w/build/baseline.elf
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
wire   <134>1 2026-08-16T19:47:33.410000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="1" sysUpTime="241"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.1.0" enterpriseId="32473" ip="10.0.2.15"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-08-16T19:47:33+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="1" sysUpTime="241"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.1.0" enterpriseId="32473" ip="10.0.2.15"] MSG=device started
```

## Self-check (vs measurements/hmac.csv)

```text
  OK    flash_text: 362912 (expected 362912, Δ0)
  OK    flash_data: 644 (expected 644, Δ0)
  OK    static_bss: 148016 (expected 148016, Δ0)
  OK    heap_used: 4440 (expected 4440, Δ0)
  OK    mbedtls_peak: 36064 (expected 36080, Δ16)
  OK    mbedtls_free: 18208 (expected 18192, Δ16)
  OK    lwip_mem_free: 7576 (expected 7576, Δ0)
  OK    lwip_pbufs_free: 13 (expected 14, Δ1)
  OK    stack_log: 800 (expected 800, Δ0)
  OK    stack_service: 3820 (expected 3820, Δ0)
  OK    stack_harness: 2848 (expected 2848, Δ0)
```

**RESULT: PASS**
