# docker_101

<!-- <img src="https://user-images.githubusercontent.com/4097471/144654508-823c6e31-5e10-404c-9f9f-0d6b9d6ce617.jpg" width="300"> -->

## Summary
Docker presentation and demo for Python in the Grass 🐍 🌱

### Caveat Emptor
Very little of this gets tested on Windows hosts. Windows Subsystem for Linux (WSL) is used where necessary with the default Ubuntu LTS install. Moved bulk of document to the [docs](docs/) directory to opt-in vs. opt-out of documentation.


**Table of Contents**
* [docker\_101](#docker_101)
  * [Summary](#summary)
    * [Caveat Emptor](#caveat-emptor)
  * [Setup](#setup)
  * [Usage](#usage)
    * [Mac and Linux users](#mac-and-linux-users)
    * [Create virtual environment](#create-virtual-environment)
    * [Run the application](#run-the-application)
      * [CLI bits](#cli-bits)
      * [Clicky-clicky](#clicky-clicky)
  * [Pushing to Docker Hub with CI](#pushing-to-docker-hub-with-ci)
    * [What you need to modify in this file](#what-you-need-to-modify-in-this-file)
  * [TODO](#todo)

## Setup
* Install
    * [editorconfig](https://editorconfig.org/)
    * [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
    * [poetry](https://python-poetry.org/docs/)
    * [docker-compose](https://docs.docker.com/compose/install/)
    * [justfile](https://just.systems/man/en/)
    * [wsl](https://docs.microsoft.com/en-us/windows/wsl/setup/environment)
* [Setup asdf](docs/asdf.md)
* [Setup poetry](docs/poetry.md)

## Usage
### Mac and Linux users
Development environments and tooling are first-class citizens on macOS and *nix. For Windows faithfuls, please setup [WSL](markdown/wsl.md).

### Create virtual environment
```bash
# install python w/asdf
asdf list python
asdf install python 3.11.3

# create virtual environment
poetry config virtualenvs.in-project true
poetry env use python
poetry install --no-root
```

### Run the application
#### CLI bits
```bash
# poetry
poetry run ./startup.sh <override_port>             # ctrl-c to exit

# docker
docker build -t my-hello-world -f Dockerfile.web .
docker run -it --rm -p 80:3000 my-hello-world       # ctrl-c to exit
docker exec -it my-hello-world bash                 # ctrl-d to exit

# docker-compose
docker-compose build --no-cache --parallel
docker-compose up -d
docker-compose down --remove-orphans

# justfile
just                                                # list all options
## docker
just run                                            # ctrl-c to exit
just exec                                           # ctrl-d to exit
## docker-compose
just build-clean                                    # docker-compose build --no-cache --parallel
just up                                             # docker-compose up -d
just down                                           # docker-compose down --remove-orphans
```
#### Clicky-clicky
Copy the `.env.example` file to `.env` and modify the values as needed.

Default port is `3000`. If you want to override the port, pass it as an argument to the `startup.sh` script.

Open a browser to either the override port or the default port to see the application running (e.g. `http://localhost:3000`).

Available endpoints are `/docs` and `/message/{msg}`; latter encodes whitespace as `%20` automatically.

## Pushing to Docker Hub with CI
Docker Hub is a cloud-based repository in which Docker users and partners create, test, store and distribute container images. Docker images are pushed to Docker Hub through the `docker push` command. A single Docker Hub repository can hold many Docker images (stored as tags).

Automated CI is implemented via GitHub Actions to build and push this repository's image to Docker Hub in `.github/workflows/ci.yml`.

### What you need to modify in this file
* Add repository secrets (Docker Hub)
  * `DOCKERHUB_TOKEN`
  * `DOCKERHUB_USER`
* Add environment variable (image name)
  * `APP_NAME` 

[Instructions to create a token](https://docs.docker.com/docker-hub/access-tokens/#create-an-access-token).

[Instructions to disable this action](https://docs.github.com/en/actions/managing-workflow-runs/disabling-and-enabling-a-workflow) if you don't want this feature.

## TODO
* [Open Issues](https://github.com/pythoninthegrass/docker_101/issues)
