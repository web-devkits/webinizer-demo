# Demo Applications for Webinizer

> [!IMPORTANT]\
> Webinizer is now in **_Beta_** trial. We'd greatly appreciate your feedback!

## About

Webinizer is a collection of tools to convert native applications, such as these programmed by
C/C++/Rust, to Web applications which are constructed by HTML/CSS/JavaScript and WebAssembly.

Webinizer consists of two parts; a core engine that analyzes the code and then either fixes or
highlights issues, and a web frontend to configure projects and display results. This repo is the
web frontend, for the core engine see the [webinizer](https://github.com/intel/webinizer) repo.

This is the demo applications repo for Webinizer with below critical entries.

- [build/](./build/): provides the scripts to build the Docker image.
- [native_projects/](./native_projects/): provides the native source code of the demo projects.
- [demos/](./demos/): provides the tutorials for building each demo project and the demo scripts to
  run. In the folder of each demo project:
  - `README.md` contains detailed instructions on building each demo project.
  - `run.sh` setup and launches the server for demo.

## Run Webinizer with Docker (recommended)

Webinizer provides scripts to build a Docker image that will setup everything for you and make
Webinizer ready to use out of the box.

This is recommended and the detailed instructions are available at
[build/Docker_README.md](./build/Docker_README.md).

## Run Webinizer locally

Webinizer also supports running locally without Docker. Currently this is validated on Linux
(`Ubuntu 20.04`). Below are the required tools and packages to run Webinizer locally.

- git
- node >= 16 and npm >= 8.15.0
- python3
- cmake
- curl
- build-essential

### Setup

First clone this repo and then run `setup.sh`

```sh

git clone https://github.com/intel/webinizer-demo.git mydemo

cd mydemo

./setup.sh

```

### Start

The demo needs to start two servers:

- The backend server which runs the core functionalities
- The web server which provides Web based UI

You'd better have two shell terminals opened. In the first shell terminal, run

```sh
./run-backend-server.sh
```

And in another shell terminal, run

```sh
./run-web-server.sh

```

### Use

Open `http://localhost:18888` on the same PC which runs above servers.

## Coding conventions

It's preferred to use [VS Code](https://code.visualstudio.com/) for development.

It's preferred to use Prettier formatter, along with `Format on Save`. Please setup the
[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) extension and
configure them accordingly.

NOTE that we set printWidth as 100 and tab width as 2.
