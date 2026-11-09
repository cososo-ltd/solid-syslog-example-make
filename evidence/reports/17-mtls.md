# solid-syslog-example — run (mtls)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[device]   first record logged: yes
[device] provisioning the renewed certificate's pin...
[device] collector renewing its certificate...
[device]   collector renewed: yes
[syslog] WARNING StreamSender SENDER_DELIVERY_FAILED DELIVERY_FAILED (6)
[syslog] NOTICE StreamSender SENDER_DELIVERY_RESTORED DELIVERY_RESTORED (7)
[device] retiring the previous pin...
[device]   records logged before / across / after the renewal: yes
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,375780,352620,23160
[report] flash_data,684,320,364
[report] static_bss,151520,111136,40384
[report] heap_used,4440,4440,0
[report] mbedtls_peak,37280,21360,15920
[report] mbedtls_free,19040,11408,7632
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,13,13,0
[report] stack_log,828,116,712
[report] stack_service,3400,56,3344
[report] stack_harness,2872,2840,32
[report] --- end ---
[device]   records logged: 4
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 375772	    692	 151520	 527984	  80e70	/w/build/baseline.elf
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
wire   <134>1 2026-11-08T15:45:22.360000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="1" sysUpTime="236"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-11-08T15:45:22+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="1" sysUpTime="236"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] MSG=device started
wire   <134>1 2026-11-08T15:45:25.360000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="2" sysUpTime="536"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-11-08T15:45:25+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="2" sysUpTime="536"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] MSG=device started
wire   <134>1 2026-11-08T15:45:28.760000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="3" sysUpTime="876"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-11-08T15:45:28+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="3" sysUpTime="876"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] MSG=device started
wire   <44>1 2026-11-08T15:45:28.800000Z 10.0.2.15 solid-syslog-example - SENDER_DELIVERY_FAILED [meta sequenceId="4" sysUpTime="880"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"][solidsyslog@67478 source="StreamSender" category="SENDER_DELIVERY_FAILED" detail="DELIVERY_FAILED"] ﻿SolidSyslog event
parsed PRIORITY=44 TIMESTAMP=2026-11-08T15:45:28+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=SENDER_DELIVERY_FAILED STRUCTURED_DATA=[meta sequenceId="4" sysUpTime="880"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"][solidsyslog@67478 source="StreamSender" category="SENDER_DELIVERY_FAILED" detail="DELIVERY_FAILED"] MSG=SolidSyslog event
wire   <45>1 2026-11-08T15:45:29.090000Z 10.0.2.15 solid-syslog-example - SENDER_DELIVERY_RESTORED [meta sequenceId="5" sysUpTime="909"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"][solidsyslog@67478 source="StreamSender" category="SENDER_DELIVERY_RESTORED" detail="DELIVERY_RESTORED"] ﻿SolidSyslog event
parsed PRIORITY=45 TIMESTAMP=2026-11-08T15:45:29+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=SENDER_DELIVERY_RESTORED STRUCTURED_DATA=[meta sequenceId="5" sysUpTime="909"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"][solidsyslog@67478 source="StreamSender" category="SENDER_DELIVERY_RESTORED" detail="DELIVERY_RESTORED"] MSG=SolidSyslog event
wire   <134>1 2026-11-08T15:45:31.760000Z 10.0.2.15 solid-syslog-example - BOOT [meta sequenceId="6" sysUpTime="1176"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] ﻿device started
parsed PRIORITY=134 TIMESTAMP=2026-11-08T15:45:31+00:00 HOSTNAME=10.0.2.15 APP_NAME=solid-syslog-example PROCID= MSGID=BOOT STRUCTURED_DATA=[meta sequenceId="6" sysUpTime="1176"][timeQuality tzKnown="1" isSynced="0"][origin software="solid-syslog-example" swVersion="0.4.0" enterpriseId="32473" ip="10.0.2.15"][logPipeline@32473 transport="mtls" atRest="hmac-sha256"] MSG=device started
```

**RESULT: PASS**
