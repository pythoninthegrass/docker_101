# https://just.systems/man/en

# load .env
set dotenv-load

# set env var
export APP      := `echo ${APP_NAME}`
export IMAGE	:= `echo ${IMAGE}`
export SCRIPT   := "startup.sh"
export SHELL	:= "/bin/bash"
export TAG		:= `git rev-parse --short HEAD`
VERSION 		:= `cat VERSION`

# x86_64/arm64
arch := `uname -m`

# hostname
host := `uname -n`

# [halp]   list available commands
default:
	just --list

# lint sh script
checkbash:
    #!/usr/bin/env bash
    checkbashisms {{SCRIPT}}
    if [[ $? -eq 1 ]]; then
        echo "bashisms found. Exiting..."
        exit 1
    else
        echo "No bashisms found"
    fi

# [checkbash] build locally or on intel box
build: checkbash
    #!/usr/bin/env bash
    set -euxo pipefail
    if [[ {{arch}} == "arm64" ]]; then
        docker build -f Dockerfile.web -t {{APP}} --build-arg CHIPSET_ARCH=aarch64-linux-gnu .
    else
        docker build -f Dockerfile.web --progress=plain -t {{APP}} .
    fi

# [docker] arm build w/docker-compose defaults
build-clean: checkbash
    docker-compose build --pull --no-cache --build-arg CHIPSET_ARCH=aarch64-linux-gnu --parallel

# [docker] login to registry (exit code 127 == 0)
login:
	#!/usr/bin/env bash
	# set -euxo pipefail
	echo "Log into ${REGISTRY_URL} as ${USER_NAME}. Please enter your password: "
	cmd=$(docker login --username ${USER_NAME} ${REGISTRY_URL})
	if [[ $("$cmd" >/dev/null 2>&1; echo $?) -ne 127 ]]; then
		echo 'Not logged into Docker. Exiting...'
		exit 1
	fi

# [docker] tag image as latest
tag-latest:
	docker tag {{APP}}:latest {{IMAGE}}/{{APP}}:latest

# [docker] tag latest image from VERSION file
tag-version:
	@echo "create tag {{APP}}:{{VERSION}} {{IMAGE}}/{{APP}}:{{VERSION}}"
	docker tag {{APP}} {{IMAGE}}/{{APP}}:{{VERSION}}

# [docker] push latest image
push: login
	docker push {{IMAGE}}/{{APP}}:{{TAG}}

# [docker] pull latest image
pull: login
	docker pull {{IMAGE}}/{{APP}}

# [docker] run container
run: build
	#!/usr/bin/env bash
	# set -euxo pipefail
	docker run --rm -it \
	--name {{APP}} \
	--env-file .env \
	-h ${HOST:-localhost} \
	-v $(pwd):/app \
	-p ${OVER_PORT:-$PORT}:${OVER_PORT:-$PORT} \
	"{{APP}}"

# [docker] start docker-compose container
up:
	docker-compose up -d

# ssh into container
exec:
    docker exec -it {{APP}} {{SHELL}}

# [docker] stop docker-compose container
stop:
	docker-compose stop

# [docker] remove docker-compose container(s) and networks
down: stop
	docker-compose down --remove-orphans
