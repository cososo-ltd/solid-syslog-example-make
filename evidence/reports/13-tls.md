# solid-syslog-example — run (tls)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,374476,352620,21856
[report] flash_data,676,320,356
[report] static_bss,149352,111136,38216
[report] heap_used,4440,4440,0
[report] mbedtls_peak,36160,21360,14800
[report] mbedtls_free,18112,11408,6704
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,14,13,1
[report] stack_log,828,116,712
[report] stack_service,3400,56,3344
[report] stack_harness,2840,2840,0
[report] --- end ---
[device]   records logged: 1
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 374468	    684	 149352	 524504	  800d8	/w/build/baseline.elf
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
wire   <134>1 2026-11-08T15:41:33.310000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="1" sysUpTime="231"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-11-08T15:41:33+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="1" sysUpTime="231"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"] MSG=device started
```

**RESULT: PASS**
