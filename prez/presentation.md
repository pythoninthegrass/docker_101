autoscale: false
footer: Intro to Docker @ Pythonistas
presenter-notes: text-scale(1.5), alignment(left), Helvetica
slidenumbers: false
theme: Work 2.0

[.background-color: #f9f8f7]
[.header: text-scale(1.4)]
[.text: text-scale(0.8), alignment(center)]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

# Intro to Docker

![left, original, 118%](img/whale.png) 

![right, original, 145%](img/avocado.png)

---

[.background-color: #f9f8f7]
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

[.header: text-scale(1.4)]
[.background-color: #f9f8f7]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Topics

**Covered**

* Brief explanation and history
* Setup environment
* Dockerfile
* Docker Compose
* Upload to Docker Hub registry
* Continuous Integration

![](img/whale.png)

---

[.header: text-scale(1.4)]
[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
[.code: Menlo, text-scale(0.8), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: alignment(left), line-height(1.0)]

## Brief Explanation of Containers 
### [^freecodecamp]

[.column]
### Virtual Machines
![original](img/vm_diagram.png)

[.column]
### Containers
![original](img/container_diagram.png)

[^freecodecamp]: [Docker vs Virtual Machine (VM) – Key Differences You Should Know](https://www.freecodecamp.org/news/docker-vs-vm-key-differences-you-should-know/)

---

[.background-color: #f9f8f7]
[.text: text-scale(0.6)]
[.code: Menlo, text-scale(0.8), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: alignment(left), line-height(1.0)]

## Brief History of Containers 
### [^docker-handbook]

![original, fill, 57%](img/container_history.jpg)

[^docker-handbook]: [Containerization History - Docker Handbook](https://borosan.gitbook.io/docker-handbook/containerization-history)

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

[.background-color: #f9f8f7]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Setup

Instructions for macOS below ([Windows](https://docs.docker.com/desktop/install/windows-install/), [Linux](https://docs.docker.com/desktop/install/linux-install/#generic-installation-steps))

![inline, 125%](img/setup.png)

---

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
[.code: Menlo, text-scale(0.8), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: alignment(left), line-height(1.0)]

## `Dockerfile` vs. `docker-compose.yml`

[.column]
### `Dockerfile`
```docker
FROM awesome/webapp
COPY . /usr/src/app
CMD ["python", "app.py"]
```

[.column]
### `docker-compose.yml`
```yaml
services:
  frontend:
    image: awesome/webapp
    ports:
      - "443:8043"
    networks:
      - front-tier
      - back-tier
    configs:
      - httpd-config
    secrets:
      - server-certificate

  backend:
    image: awesome/database
    volumes:
      - db-data:/etc/data
    networks:
      - back-tier

volumes:
  db-data:
    driver: flocker
    driver_opts:
      size: "10GiB"

configs:
  httpd-config:
    external: true

secrets:
  server-certificate:
    external: true

networks:
  # The presence of these objects is sufficient to define them
  front-tier: {}
  back-tier: {}
```

---

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
[.code: Menlo, text-scale(0.8), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: alignment(left), line-height(1.0)]

## `Dockerfile` vs. `docker-compose.yml`

[.column]
### `Dockerfile`
* Domain Specific Language (DSL)
* Builds an image
* Interpreted

[.column]
### `docker-compose.yml`
* Yet Another Markup Language (YAML)
* Definines services, networks, and volumes for a Docker application
  * Can build local image from `Dockerfile` or use remote image on a container registry
* Runtime based on element level and global directives

---

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: alignment(left), line-height(1.0)]

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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`RUN`](https://docs.docker.com/engine/reference/builder/#run)
> The `RUN` instruction will execute any commands in a new layer on top of the current image and commit the results.<br/>
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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`ENTRYPOINT`](https://docs.docker.com/engine/reference/builder/#entrypoint)

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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`CMD`](https://docs.docker.com/engine/reference/builder/#cmd)
> The main purpose of a `CMD` is to provide defaults for an executing container.<br/>
> There can only be one CMD instruction in a Dockerfile.<br/>
> If you list more than one CMD then only the last CMD will take effect.<br/>

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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]
<!-- [.footer-style: alignment(left)] -->

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`CMD`](https://docs.docker.com/engine/reference/builder/#cmd)

The `CMD` instruction has three forms:
- `CMD` ["executable", "param1", "param2"] 
  - exec form, this is the _preferred_ form
- `CMD` ["param1", "param2"] 
  - as default parameters to `ENTRYPOINT`
- `CMD` command param1 param2 (shell form)

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: 40]

---

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`VOLUME`](https://docs.docker.com/engine/reference/builder/#volume)

The `VOLUME` instruction creates a mount point with the specified name and marks it as holding externally mounted volumes from native host or other containers.

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: all]

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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`VOLUME`](https://docs.docker.com/engine/reference/builder/#volume)

Wait. 

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: none]

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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`VOLUME`](https://docs.docker.com/engine/reference/builder/#volume)

Where __**is**__ `VOLUME`??

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: none]

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

[.background-color: #f9f8f7]
[.text: text-scale(0.8)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`VOLUME`](https://docs.docker.com/engine/reference/builder/#volume)

You __could__ do this:

```dockerfile
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
VOLUME /myvol
```

[.code: Menlo, text-scale(2.0), line-height(0.8), alignment(left)]
[.code-highlight: none]

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

[.background-color: #f9f8f7]
[.text: text-scale(0.7)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
[`VOLUME`](https://docs.docker.com/engine/reference/builder/#volume)

But then...
> __The host directory is declared at container run-time__: The host directory (the mountpoint) is, by its nature, host-dependent.
<br/>
> This is to preserve image portability, since a given host directory can’t be guaranteed to be available on all hosts.<br/>
> For this reason, you can’t mount a host directory from within the `Dockerfile`. The `VOLUME` instruction does not support specifying a `host-dir` parameter.<br/>
> You must specify the mountpoint when you create or run the container.

---

[.background-color: #f9f8f7]
[.text: text-scale(0.7)]

## Dockerfile

### Common Directives

[.code: Menlo, text-scale(1.0), line-height(0.8), alignment(left)]

[.column]
__Ergo__, declaring a `VOLUME` in a `Dockerfile` is __useless__*.
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
* Except as documentation (cf. `EXPOSE`)

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 1-3]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 3-6]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 7-9]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 10-12]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 13-15]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 16-18]

## Docker Commands

[.column]

```bash
# show running containers
docker ps

# show images
docker images

# build docker image and tag
docker build -t helloworld .

# run image with interactive tty and remove container after
docker run -it --rm helloworld

# run image with volume mount and map port
docker run -it --rm -v $(pwd):/app -p 3000:3000 helloworld

# run image in background (detached) with shortened name 'hello'
docker run -it -d -name hello helloworld
```

---

[.background-color: #f9f8f7]
[.header: text-scale(2.0), alignment(center)]
[.text: text-scale(0.8), alignment(center)]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Demo Time
### Dockerfile

<!-- TODO: embedded jupyter notebook? -->

<!-- https://rew-online.com/demolition-one-of-the-last-ways-to-deregulate-a-building/ -->

---

[.background-color: #f9f8f7]

<!-- BLANK SLIDE -->

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]

## Docker Compose (file)
### Bird's Eye View

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 1,3,22]

## Docker Compose (file)
### top-level keys

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 1]

## Docker Compose (file)
### version

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 3-5]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,6]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,7,18-20]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,8]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

<!-- PRESENTER -->
^ ### services - tty
* tty: default is true; allocates pseudo-TTY (`docker exec -t`)
  * teleprinters -> teletypes (TTY)
  * In Linux, there is a pseudo-teletype multiplexor which handles the connections from all of the terminal window pseudo-teletypes (PTS)

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,9]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

<!-- PRESENTER -->
^ ### services - stdin_open
* stdin_open: default is true; keep STDIN open even if not attached (`docker exec -i`)
  * STDIN: standard input
  * STDOUT: standard output
  * STDERR: standard error

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,10-11]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,12-13]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,14-15]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4,16-17]

## Docker Compose (file)
### services

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 21,22-23]

## Docker Compose (file)
### networks

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 21,22-24]

## Docker Compose (file)
### networks

```yaml
version: "3.9"

services:
  helloworld:
    container_name: hello-world
    platform: linux/amd64         # linux/amd64 / linux/arm64/v8
    image: hello-world
    tty: false                    # false for `entrypoint` in Dockerfile
    stdin_open: false             # false for `entrypoint` in Dockerfile
    env_file:
      - ./.env
    environment:
      - PIP_DISABLE_PIP_VERSION_CHECK=off
    volumes:
      - .:/app
    ports:
      - 3000:3000/tcp
    build:
      context: ./
      dockerfile: ./Dockerfile.web

networks:
  default:
    driver: bridge                # bridge / host / none
```

<!-- PRESENTER -->
^ ### network drivers
* bridge: private network internal to host so containers on this network can communicate via exposed ports
* host: networking provided by the host machine
* none: disable all networking

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: all]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 1-2]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 4-5]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 7-8]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 10-11]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.text: text-scale(1.0)]
[.code-highlight: 13-14]

## Docker Compose (commands)

```bash
# clean build (remove --no-cache for speed,
docker-compose build --no-cache --parallel

# start container
docker-compose up --remove-orphans -d

# exec into container
docker attach hello

# stop container
docker-compose stop

# destroy container and network
docker-compose down
```

---

[.background-color: #f9f8f7]
[.header: text-scale(2.0), alignment(center)]
[.text: text-scale(0.8), alignment(center)]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Demo Time
### Docker Compose

<!-- TODO: embedded jupyter notebook? -->

<!-- https://rew-online.com/demolition-one-of-the-last-ways-to-deregulate-a-building/ -->

---

[.background-color: #f9f8f7]

<!-- BLANK SLIDE -->

---

[.background-color: #f9f8f7]
[.header: text-scale(4.0), alignment(center)]
[.text: text-scale(0.8), alignment(center)]
[.code: Menlo, text-scale(0.8), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

<!-- TODO: embedded jupyter notebook? -->
## [Star Wars ASCII Container](https://github.com/gabe565/ascii-movie)

![fill](img/death_star_1920x1080.png)

```
docker run --rm -it ghcr.io/gabe565/ascii-movie play
```

---

[.background-color: #f9f8f7]
[.header: text-scale(3.5), alignment(center)]
[.text: text-scale(0.8), alignment(left)]
[.code: Menlo, text-scale(0.7), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

# Thank You!

* [Hartwig Staffing](https://hartwigstaffing.com/)
* [OKC Coffee & Code](https://www.meetup.com/okccoffeeandcode/)
* [Techlahoma](https://www.techlahoma.org/)
* [Gabe Cook](https://github.com/gabe565)
  * For salvaging the `telnet` [Star Wars ASCII video](https://github.com/gabe565/ascii-movie) and leveling it up

---

[.background-color: #f9f8f7]
[.header: text-scale(3.5), alignment(center)]
[.text: text-scale(0.8), alignment(center)]
[.code: Menlo, text-scale(0.7), line-height(0.8), alignment(left)]
[.code-highlight: all]
[.footer-style: #2F2F2F, alignment(left), line-height(1.0)]

## Repo (One Last Time)

[https://github.com/pythoninthegrass/docker_101](https://github.com/pythoninthegrass/docker_101)

![inline](img/qr.png)
