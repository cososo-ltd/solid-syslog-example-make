# solid-syslog-example — run (header-fields)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,354776,349808,4968
[report] flash_data,448,316,132
[report] static_bss,111112,110876,236
[report] heap_used,4440,4440,0
[report] mbedtls_peak,21240,21328,-88
[report] mbedtls_free,11528,11440,88
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,14,13,1
[report] stack_log,136,120,16
[report] stack_service,52,52,0
[report] stack_harness,2848,2840,8
[report] --- end ---
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 354768	    456	 111112	 466336	  71da0	/w/build/baseline.elf
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
wire   <134>1 2026-07-31T18:49:13.360000Z 10.0.2.15 solid-syslog-example - BOOT - ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-07-31T18:49:13+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA= MSG=device started
```

## Self-check (vs measurements/header-fields.csv)

```text
  OK    flash_text: 354776 (expected 354776, Δ0)
  OK    flash_data: 448 (expected 448, Δ0)
  OK    static_bss: 111112 (expected 111112, Δ0)
  OK    heap_used: 4440 (expected 4440, Δ0)
  OK    mbedtls_peak: 21240 (expected 21240, Δ0)
  OK    mbedtls_free: 11528 (expected 11528, Δ0)
  OK    lwip_mem_free: 7576 (expected 7576, Δ0)
  OK    lwip_pbufs_free: 14 (expected 14, Δ0)
  OK    stack_log: 136 (expected 136, Δ0)
  OK    stack_service: 52 (expected 52, Δ0)
  OK    stack_harness: 2848 (expected 2848, Δ0)
```

**RESULT: PASS**
