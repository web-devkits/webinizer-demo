# Run with Docker

## Files in the Package

You should have these files in the release package:

- `webinizer_img.tar` - this is the docker image to be installed.
- `webinizer_demo` - this is the directory containing the native projects to demo and start script.
- `README.md` - this file itself.

## Setup

You should have `docker` installed and properly
[configured](./Docker_README.md#configure-docker-in-the-local-system) in your local system.

```sh
# Ensure that you are in the directory of the released package
docker load<webinizer_img.tar

# you should see webinizer listed below
docker image ls | grep webinizer
```

## Run the Demo

```sh
# Ensure that you are in the directory of the released package
cd webinizer_demo
./run.sh $(pwd)/native_projects 18888

```

The `run.sh` script will guide you through some user configurations setup for `webinizer` before
launching the container. Then you should be able to access webinizer at `http://127.0.0.1:18888`.
