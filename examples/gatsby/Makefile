.DEFAULT_GOAL	:= help
.ONESHELL:
export SHELL 	:= $(shell which bash)
# .SHELLFLAGS 	:= -eu -o pipefail -c
# MAKEFLAGS 		+= --warn-undefined-variables

# ENV VARS
export UNAME 	:= $(shell uname -s)

# colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

# targets
.PHONY: all
all: init dev open help

init: ## create a new gatsby site using the minimal typescript starter
	[[ ! -d "my-gatsby-site" ]] && npm init gatsby || echo "my-gatsby-site already exists"

dev: init ## start the site in development mode
	cd my-gatsby-site; \
	yarn develop

# TODO: QA
open: ## open the site in your browser
	@echo "Opening http://localhost:8000"
	num_fields(): ps aux | grep -E "node.*yarn develop" | grep -v grep | awk '{print NF}'); \
	get_field(): expr $$num_fields - 1); \
	sec_to_last=$(get_field); \
	check_proc(): ps aux | grep -E "node.*yarn develop" | grep -v grep | awk '{print $'$sec_to_last', $NF}'); \
	ret_code=$$?; \
	while [ $$ret_code -ne 0 ]; do \
		sleep 10; \
		check_proc(); \
		ret_code=$$?; \
	done; \
	if [ "$(UNAME)" = "Darwin" ]; then \
		open http://localhost:8000; \
	elif [ "$(UNAME)" = "Linux" ]; then \
		xdg-open http://localhost:8000; \
	fi

all: init dev open ## run all targets

help: ## show this help
	@echo ''
	@echo 'Usage:'
	@echo '    ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
