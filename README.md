# Mikrotik Tailscale Proxy

This project extends the [Fluent Networks Tailscale container](https://github.com/Fluent-networks/tailscale-mikrotik) for MikroTik by adding an embedded NGINX reverse proxy to expose internal MikroTik services (like WebFig) to Tailscale clients in a secure and configurable way.

## 🚀 Features

- NGINX reverse proxy with automatic config generation
  - Support for multiple internal targets via `WEBPROXY_TARGETS` env var
- Deployable on MikroTik RouterOS with container support

## Example
This assumes you have followed the [Fluent-Networks](https://github.com/Fluent-networks/tailscale-mikrotik) instructions.
```
/container/envs 
add name="tailscale" key="WEBPROXY_TARGETS" value="192.168.88.1:80@"
/container add remote-image=p-net-no/mikrotik-tailscale-proxy:latest interface=veth1 envlist=tailscale root-dir=disk1/containers/tailscale mounts=tailscale start-on-boot=yes h
ostname=mikrotik dns=1.1.1.1,8.8.8.8 logging=yes
```
