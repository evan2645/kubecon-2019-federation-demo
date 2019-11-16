# KubeCon 2019 Istio/SPIRE Federation Demo
**This repository is currently a WORK IN PROGRESS.**

The scripts and configuration files in this repository are intended to set up a simple SPIRE deployment, and facilitate the introduction of an Istio cluster to a SPIRE cluster via SPIFFE Federation.

This is an example only. In addition to changes in Istio Pilot, the [Istio Federation Server](https://github.com/evan2645/istio-federation-server) is currently required to make this demo work in its entirety.

## Prerequisites and Assumptions
In optimizing for speed of demo development, this example makes a large number of assumptions:
* Istio trust domain is named `cluster-1`
* SPIRE deployment is run in GCP
* GCP Project ID is `kubecon19-demo`
* The Linux username being used to run the demo is `evan`
* The SPIRE Server instance name is `spire-server-1`
* The SPIRE Agent/workload instance name is `spire-workload-1`
* The SPIFFE ID of the Istio workload calling in is `spiffe://cluster-1/ns/foo/sa/sleep`

At least one of these assumptions are guaranteed to not hold true in other environments. That said, grepping this repository for the referenced strings should expose the spots that need to be udpated to get this demo working in your own environment.

In addition to the above assumptions, the included scripts rely on the following utilities being available in $PATH:
* `curl`
* `tar`
* `python` version 2.X

## Running the Demo
This section describes the steps necessary to complete the demo.

### Setup
Run the setup script on both GCP instances with sudo:
```
evan@spire-server-1:~$ sudo ./00-setup.sh
```
and
```
evan@spire-workload-1:~$ sudo ./00-setup.sh
```

This will install SPIRE and Ghostunnel.

### Start SPIRE Server
On `spire-server-1`, start the SPIRE Server and create registration entries for the workload we will be starting:
```
evan@spire-server-1:~$ ./01-start-spire-server.sh
```

SPIRE Server will be started in the background, and you will be returned to the command prompt.

### Start SPIRE Agent
On `spire-workload-1`, start the SPIRE Agent:
```
evan@spire-workload-1:~$ ./02-start-spire-agent.sh
```

SPIRE Agent will be started in the background, and you will be returned to the command promt.

### Start the Workload
On `spire-workload-1`, start a simple HTTP server and an mTLS proxy to serve as the workload for this demo:
```
evan@spire-workload-1:~$ ./03-start-workload.sh
```

The HTTP server will be started in the background, and the mTLS proxy will start in the foreground.

### Federate the Workload
On `spire-server-1`, alter the workload's registration entry to specify that it should federate with the `spiffe://cluster-1` trust domain. This step will require the root CA certificate(s) from Istio. When prompted, paste the root certificate(s) on STDIN and send an EOF (ctrl+d).
```
evan@spire-server-1:~$ ./04-federate-with-istio.sh
Please paste the CA certificate(s) for the trust domain "cluster-1":
-----BEGIN CERTIFICATE-----
MIIBjzCCARWgAwIBAgIBADAKBggqhkjOPQQDAzAAMB4XDTE5MTExNTAwNDUyMloX
DTE5MTExNjAwNDUzMlowADB2MBAGByqGSM49AgEGBSuBBAAiA2IABG05ZCqPN+DN
RAHKL3CZt4JQIDExe6L92yk+VKiUgrBCPzguWmqyDW9fkvoh830b0d1gieHoHcAb
37jyVfkbk+GJC6dA/Rd6zS4XeXKpQ0v62Wnoppkttl16GRKi95IL/aNjMGEwDgYD
VR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFDYjqd8JYhQ1
t+drLz25hM+I2ytEMB8GA1UdEQEB/wQVMBOGEXNwaWZmZTovL2NsdXN0ZXIyMAoG
CCqGSM49BAMDA2gAMGUCMFoUgOEmYuKFdre6wAbDnq7VZClQnWb39ZcDyfWRiL19
ynURROFe3NhuTAcKTfjHJAIxANV3aw9+3Y82jSL06Tmnzk+RN9FL7UlZW3aCAHhG
i2IS0z+CD7JbTl02KijYSI6IKA==
-----END CERTIFICATE-----

evan@spire-server-1:~$
```

The output generated from this step can be ignored. The workload is now configured to federate with Istio. You should see the mTLS proxy log an update:

```
[25316] 2019/11/16 00:50:28.899498 (spiffe) [DEBUG]: X509SVID workload API update received
```

## Cleaning Up
A cleanup script is provided that will remove the SPIRE and Ghostunnel installations, as well as artifacts downloaded as part of the install process. Please note that running processes will need to be stopped manually. Among them are `spire-server`, `spire-agent`, and `python`.
```
evan@spire-server-1:~$ ./90-clean.sh
```

