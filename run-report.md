# solid-syslog-example — run (logger)

## Device (self-measured)

```text
[device] solid-syslog-example (FreeRTOS + lwIP + mbedTLS + FatFs)
[syslog] CRITICAL SolidSyslog bad-config (detail 1)
[syslog] CRITICAL SolidSyslog bad-config (detail 2)
[syslog] CRITICAL SolidSyslog bad-config (detail 3)
[device] starting simulated existing application...
[sim] broker session to 10.0.2.2:8883: TLSv1.3, TLS1-3-CHACHA20-POLY1305-SHA256
[device]   sim app (lwIP up, FatFs mounted, broker session held over mTLS): ready
[report] --- SolidSyslog cost above baseline (simulated existing application) ---
[report] key,current,baseline,used_above_baseline
[report] flash_text,350800,349808,992
[report] flash_data,384,316,68
[report] static_bss,110992,110876,116
[report] heap_used,4440,4440,0
[report] mbedtls_peak,21260,21328,-68
[report] mbedtls_free,11508,11440,68
[report] lwip_mem_free,7576,7576,0
[report] lwip_pbufs_free,14,13,1
[report] stack_log,120,120,0
[report] stack_service,52,52,0
[report] stack_harness,2840,2840,0
[report] --- end ---
[device] ready
```

### Size cross-check

```text
   text	   data	    bss	    dec	    hex	filename
 350792	    392	 110992	 462176	  70d60	/w/build/baseline.elf
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
(nothing — this device sends no records yet)
```

## Self-check (vs measurements/logger.csv)

```text
  OK    flash_text: 350800 (expected 350800, Δ0)
  OK    flash_data: 384 (expected 384, Δ0)
  OK    static_bss: 110992 (expected 110992, Δ0)
  OK    heap_used: 4440 (expected 4440, Δ0)
  OK    mbedtls_peak: 21260 (expected 21212, Δ48)
  OK    mbedtls_free: 11508 (expected 11556, Δ48)
  OK    lwip_mem_free: 7576 (expected 7576, Δ0)
  OK    lwip_pbufs_free: 14 (expected 13, Δ1)
  OK    stack_log: 120 (expected 120, Δ0)
  OK    stack_service: 52 (expected 52, Δ0)
  OK    stack_harness: 2840 (expected 2840, Δ0)
```

**RESULT: PASS**
