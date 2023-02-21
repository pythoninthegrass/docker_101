# -*- mode: GNUmakefile; indent-tabs-mode: t -*-

# TODO: debug why it immediately crashes current terminal

SHELL 			:= /bin/bash
.DEFAULT_GOAL	:= help

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all

all: help homebrew just install xcode

xcode:  ## install xcode command line tools
	@echo "Installing Xcode command line tools..."
	$(xcode-select --install)

homebrew:  ## install homebrew
	@echo "Installing Homebrew..."
	$(/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

just:  ## install justfile
	@echo "Installing Justfile..."
	$(brew install just)

install: xcode homebrew just  ## install all dependencies

help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
