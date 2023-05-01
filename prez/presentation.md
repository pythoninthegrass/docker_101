autoscale: false
footer: Docker 101 @ Pythonistas
slidenumbers: true
theme: Work 2.0
[.text: text-scale(0.8), alignment(center)]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

# Intro to Docker

![inline, fill, 119%](img/whale.png) ![inline, 135%](img/avocado.png)

---

[.text: text-scale(0.8)]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Intro

**Lance Stephens**

Been in the game for over a decade. Was a DevOps engineer at Greenhouse Software until May 2023 (3.5 years). 

Now [#opentowork](https://www.linkedin.com/in/lancestephens/)!

Extracurriculars include community organizing with [Pythonistas](https://www.meetup.com/pythonistas/) (founder) and [Coffee & Code](https://www.meetup.com/okccoffeeandcode/), volunteering with [ReMerge](https://www.remergeok.org/), going to concerts, and travel.

<!-- ![right, fill, original](img/me.jpg) -->
![right, 195%](img/me.jpg)

---

[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Topics

**Covered**

* Setup environment
* Dockerfile
* Docker Compose
* Upload to Docker Hub registry
* Continuous Integration

![](img/whale.png)

---

[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Topics

**Out of Scope**

* Alternatives (Podman, Kaniko, OrbStack)
* Architectures (x86, ARM)
* Buildkit
* Kubernetes (k8s)
* Cloud providers (e.g., AWS, Azure, GCP)

![](img/whale.png)

---

[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## TODO: [Star Wars ASCII Container](https://github.com/gabe565/ascii-movie)

```
docker run --rm -it ghcr.io/gabe565/ascii-movie play
```

---

[.header: #ffffff]
[.text: #ffffff]
[.footer-style: #ffffff, alignment(left), line-height(1.0)]

## Repo

<!-- <span style="color: white;">https://github.com/pythoninthegrass/docker_101)</span> -->
[https://github.com/pythoninthegrass/docker_101](https://github.com/pythoninthegrass/docker_101)

![inline](img/qr.png)

![original, 183%](img/repo.png)

---

[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Setup

Instructions for macOS below ([Windows](https://docs.docker.com/desktop/install/windows-install/), [Linux](https://docs.docker.com/desktop/install/linux-install/#generic-installation-steps))

![inline](img/setup.png)

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Dockerfile

### Common Directives

[.column]
- FROM
- ARG
- ENV
- RUN
- WORKDIR
- COPY
- EXPOSE
- ENTRYPOINT
- CMD

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

<!-- ![right, original 150%](img/dockerfile.png) -->

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`FROM`](https://docs.docker.com/engine/reference/builder/#from)
> The `FROM` instruction initializes a new build stage and sets the *Base Image* for subsequent instructions. 
> 
> As such, a valid `Dockerfile` must start with a `FROM` instruction.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 1]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```
---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`ARG`](https://docs.docker.com/engine/reference/builder/#arg)
> The `ARG` instruction defines a variable that users can pass at build-time to the builder...
>
> A `Dockerfile` may include one or more `ARG` instructions.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 4]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```
---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`ENV`](https://docs.docker.com/engine/reference/builder/#env)
> The `ENV` instruction sets the environment variable `<key>` to the value `<value>`. This value will be in the environment for all subsequent instructions in the build stage and can be replaced inline in many as well.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 10-22]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```
---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`RUN`](https://docs.docker.com/engine/reference/builder/#run)
> The `RUN` instruction will execute any commands in a new layer on top of the current image and commit the results.
>  
> The resulting committed image will be used for the next step in the `Dockerfile`.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 6-9,23-25,30-35]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```
---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(0.7), line-height(0.8), alignment(left)]

[.column]
[`WORKDIR`](https://docs.docker.com/engine/reference/builder/#workdir)
> The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the `Dockerfile`.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 24,26]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`COPY`](https://docs.docker.com/engine/reference/builder/#copy)
> The `COPY` instruction copies new files or directories from `<src>` and adds them to the filesystem of the container at the path <dest>.

```dockerfile
COPY [--chown=<user>:<group>] [--chmod=<perms>] ["<src>",... "<dest>"]
```

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 28-29]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`EXPOSE`](https://docs.docker.com/engine/reference/builder/#expose)
> The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime... [T]he default is TCP if the protocol is not specified.
> 
> The `EXPOSE` instruction does not actually publish the port. It [documents] which ports are intended to be published. 

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 36-37]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
`ENTRYPOINT`

`ENTRYPOINT` has two forms:
The exec form, which is the preferred form:
`ENTRYPOINT ["executable", "param1", "param2"]`

The shell form:
`ENTRYPOINT command param1 param2`

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 39]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
`CMD`
> The main purpose of a `CMD` is to provide defaults for an executing container.
> There can only be one CMD instruction in a Dockerfile. 
> If you list more than one CMD then only the last CMD will take effect.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 40]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---

[.background-color: #ffffffff]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
`CMD`
The `CMD` instruction has three forms:
- `CMD` ["executable", "param1", "param2"] 
  - exec form, this is the _preferred_ form
- `CMD` ["param1", "param2"] 
  - as default parameters to `ENTRYPOINT`
- `CMD` command param1 param2 (shell form)

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 40]

[.column]
```dockerfile
FROM python:3.11-slim-bullseye

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt -qq update && apt -qq install curl gcc lsof python3-dev
RUN rm -rf /var/lib/apt/lists/*

# pip env vars
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# poetry env vars
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.2
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# path
ENV VENV="/opt/venv"
ENV PATH="$POETRY_HOME/bin:$VENV/bin:$PATH"

# working directory (creates dir if it doesn't exist)
RUN mkdir -p /app
WORKDIR /app

# copy all files from current dir to working dir
COPY . .

# install poetry and dependencies
RUN python -m venv $VENV && . "${VENV}/bin/activate"
RUN python -m pip install "poetry==${POETRY_VERSION}"
RUN poetry install --no-ansi --no-root --without dev

# listening port (not published)
EXPOSE 3000

ENTRYPOINT ["python", "main.py"]
# CMD ["default", "arg"]
```

---
