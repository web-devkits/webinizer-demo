# Build and Run with Docker

## Configure docker in the local system

### Proxy settings

If you have proxy settings in your system, please follow below guides to configure properly for
docker.

- Configure proxy for docker daemon
  [guide](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy)
- Configure proxy for docker client
  [guide](https://docs.docker.com/network/proxy/#configure-the-docker-client)

### Manage docker as non-root user

- Add the docker group if it doesn't already exist:

  ```bash
  sudo groupadd docker
  ```

- Add the connected user `$USER` to the docker group. Change the user name to match your preferred
  user if you do not want to use your current user:

  ```bash
  sudo gpasswd -a $USER docker
  ```

- Either do a `newgrp docker` or log out/in to activate the changes to groups.

## Build the docker image

Clone the `webinizer-demo` project and run its build script:

```sh

git clone https://github.com/intel/webinizer-demo.git webinizer-demo

# It needs a temporary directory for build, clean it first
rm -rf temp_dir
# Build the docker image, all temporary files are under temp_dir
webinizer-demo/build/build.sh temp_dir
```

If it successfully builds, you may find `temp_dir/release` with the following items:

- `webinizer_img.tar` - this is the docker image
- `webinizer_demo` - this is the directory containing the native projects to demo

## Setup & Run

See [README.md](./README.md) for more details.
