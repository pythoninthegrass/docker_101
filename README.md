# docker_101

<!-- <img src="https://user-images.githubusercontent.com/4097471/144654508-823c6e31-5e10-404c-9f9f-0d6b9d6ce617.jpg" width="300"> -->

## Summary


### Caveat Emptor
Very little of this gets tested on Windows hosts. Windows Subsystem for Linux (WSL) is used where necessary with the default Ubuntu LTS install. Moved bulk of document to the [markdown](markdown/) directory to opt-in vs. opt-out of documentation.


**Table of Contents**
* [docker\_101](#docker_101)
  * [Summary](#summary)
    * [Caveat Emptor](#caveat-emptor)
  * [Setup](#setup)
  * [Usage](#usage)
    * [Mac and Linux users](#mac-and-linux-users)
  * [Pushing to Docker Hub with CI](#pushing-to-docker-hub-with-ci)
    * [What you need to modify in this file](#what-you-need-to-modify-in-this-file)
  * [TODO](#todo)

## Setup
* Install
    * [editorconfig](https://editorconfig.org/)
    * [wsl](https://docs.microsoft.com/en-us/windows/wsl/setup/environment)
    * [asdf](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
    * [poetry](https://python-poetry.org/docs/)
    * [docker-compose](https://docs.docker.com/compose/install/)
    * [playwright](https://playwright.dev/python/docs/intro#installation)
    * [justfile](https://just.systems/man/en/)

## Usage
### Mac and Linux users
Development environments and tooling are first-class citizens on macOS and *nix. For Windows faithfuls, please setup [WSL](markdown/wsl.md).

## Pushing to Docker Hub with CI
Docker Hub is a cloud-based repository in which Docker users and partners create, test, store and distribute container images. Docker images are pushed to Docker Hub through the `docker push` command. A single Docker Hub repository can hold many Docker images (stored as tags).

Automated CI is implemented via GitHub Actions to build and push this repository's image to Docker Hub in `.github/workflows/docker.yml`.

### What you need to modify in this file

* Look for `images: your-username/your-image-name` and change to your respective Docker Hub username and image name.
* Add a repository secret for `DOCKERHUB_TOKEN` and environment variable `DOCKERHUB_USER` on this repository on GitHub.
  * Here are the [instructions to create a token](https://docs.docker.com/docker-hub/access-tokens/#create-an-access-token).

Here are the [instructions to disable this action](https://docs.github.com/en/actions/managing-workflow-runs/disabling-and-enabling-a-workflow) if you don't want this feature.

## TODO
* [Open Issues](https://github.com/pythoninthegrass/python_template/issues)
