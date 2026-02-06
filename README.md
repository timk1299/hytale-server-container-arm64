<div align="center" width="100%">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/deinfreu/hytale-server-container/blob/main/assets/images/logo_Dark.png">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/deinfreu/hytale-server-container/blob/main/assets/images/logo_Light.png">
  <img alt="Docker Hytale Server Logo" src="https://github.com/deinfreu/hytale-server-container/blob/main/assets/images/logo_Light.png" width="800">
</picture>

**This repository is based on https://github.com/deinfreu/hytale-server-container.git, but is executable on arm64.**

Deploy a Hytale dedicated server with a community-focused Docker image by 10+ contributors. This project simplifies Hytale self-hosting with built-in security, networking and debugging tools. Join our active Discord for direct support and to connect with other server owners. Whether you're testing mods or running a persistent world, this container provides a consistent, production-ready environment in one command.

</div>

## Support & Resources

* **Documentation:** Detailed performance optimizations and security specifications are located in the [Project Docs](https://hytale-server-container.com/?utm_source=github&utm_medium=social&utm_campaign=github_readme).
* **Troubleshooting:** Check the [support](https://hytale-server-container.com/installation/support//?utm_source=github&utm_medium=social&utm_campaign=github_readme) page and our [Security Policy](SECURITY.md) before reporting issues. You can also visit our [Discord](https://discord.com/invite/2kn2T6zpaV)

## Quick start

Install docker [CLI](https://docs.docker.com/engine/install/) on linux or the [GUI](https://docs.docker.com/desktop) on windows, macos and linux

You can run the container by running this in your CLI

```bash
docker run \
  --name hytale-server \
  -e SERVER_IP="0.0.0.0" \
  -e SERVER_PORT="5520" \
  -e PROD="FALSE" \
  -e DEBUG="FALSE" \
  -e TZ="Europe/Amsterdam" \
  -p 5520:5520/udp \
  -v "hytale-server:/home/container/hytale" \
  -v "/etc/machine-id:/etc/machine-id:ro" \
  --restart unless-stopped \
  timk1299/hytale-server:latest
```

Alternatively, you can deploy using Docker Compose. Use the configuration below or explore the [examples](https://github.com/timk1299/hytale-server-container/tree/main/examples) folder for more advanced templates.

```bash
services:
  hytale:
    image: timk1299/hytale-server:latest
    container_name: hytale-server
    environment:
      SERVER_IP: "0.0.0.0"
      SERVER_PORT: "5520"
      PROD: "FALSE"
      DEBUG: "FALSE"
      TZ: "Europe/Amsterdam"
    restart: unless-stopped
    ports:
      - "5520:5520/udp"
    volumes:
      - ./data:/home/container/hytale
      - /etc/machine-id:/etc/machine-id:ro
    tty: true
    stdin_open: true
```
