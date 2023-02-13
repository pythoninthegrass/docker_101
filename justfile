# https://just.systems/man/en

# load .env
set dotenv-load

# set env var
export IMAGE	:= `echo ${REGISTRY_URL}`
export SHELL	:= "/bin/bash"
VERSION 		:= `cat VERSION`

# x86_64/arm64
arch := `uname -m`

# hostname
host := `uname -n`

# [halp]   list available commands
default:
	just --list

# [docker] build locally
build:
	#!/usr/bin/env bash
	echo "building ${APP_NAME}:${TAG}"
	if [[ {{arch}} == "arm64" ]]; then
		docker build -f Dockerfile.web -t ${APP_NAME} --build-arg CHIPSET_ARCH=aarch64-linux-gnu .
	else
		docker build -f Dockerfile.web -t ${APP_NAME} --build-arg CHIPSET_ARCH=x86_64-linux-gnu .
	fi
	echo "created tag ${APP_NAME}:${TAG} {{IMAGE}}/${APP_NAME}:${TAG}"

# [docker] intel build
buildx:
	docker buildx build -f Dockerfile --progress=plain -t ${TAG} --build-arg CHIPSET_ARCH=x86_64-linux-gnu --load .

# [docker] build w/docker-compose defaults
build-clean:
	#!/usr/bin/env bash
	if [[ {{arch}} == "arm64" ]]; then
		docker-compose build --pull --no-cache --build-arg CHIPSET_ARCH=aarch64-linux-gnu
	else
		docker-compose build --pull --no-cache --build-arg CHIPSET_ARCH=x86_64-linux-gnu
	fi

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
	@echo "create tag ${APP_NAME}:${TAG} {{IMAGE}}/${APP_NAME}:${TAG}"
	docker tag ${APP_NAME}:${TAG} {{IMAGE}}/${APP_NAME}:${TAG}

# TODO: QA
# [docker] tag latest image from VERSION file
tag-version:
	@echo "create tag ${APP_NAME}:{{VERSION}} {{IMAGE}}/${APP_NAME}:{{VERSION}}"
	docker tag ${APP_NAME} {{IMAGE}}/${APP_NAME}:{{VERSION}}

# [docker] push latest image
push: login
	docker push {{IMAGE}}/${APP_NAME}:${TAG}

# [docker] pull latest image
pull: login
	docker pull {{IMAGE}}/${APP_NAME}

# [docker] run container
run: build
	docker run --rm -it \
	--name ${APP_NAME} \
	--env-file .env \
	-v $(pwd):/app \
	-p ${PORT}:${PORT} \
	"${APP_NAME}"

# [docker] start docker-compose container
start:
	docker-compose up -d

# [docker] ssh into container
exec:
	docker-compose exec ${APP_NAME} {{SHELL}}

# [docker] stop docker-compose container
stop:
	docker-compose stop

# [docker] remove docker-compose container(s) and networks
down: stop
	docker-compose down --remove-orphans
