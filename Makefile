# -*- coding: utf-8; mode: makefile-gmake; -*-

MAKEFLAGS += --warn-undefined-variables

SHELL := bash
.SHELLFLAGS := -euo pipefail -c

HERE := $(shell cd -P -- $(shell dirname -- $$0) && pwd -P)

.PHONY: all
all: build

has-command = $(if $(shell command -v $1 2> /dev/null),,$(error The command $1 does not exist in PATH))

.PHONY: has-command-%
has-command-%:
	@$(call has-command,$*)

is-defined = $(if $(value $1),,$(error The environment variable $1 is undefined))

.PHONY: is-defined-%
is-defined-%:
	@$(call is-defined,$*)

CONTAINER_SLUG := guaranteed-rate/hello-world-container
CONTAINER_REGISTRY := ghcr.io
CONTAINER_VERSION := $(shell git rev-parse HEAD)

PORT ?= 3000

.PHONY: login
login: has-command-docker is-defined-CONTAINER_REGISTRY is-defined-GITHUB_USERNAME is-defined-GITHUB_PASSWORD
	@echo $(GITHUB_PASSWORD) | docker login --username $(GITHUB_USERNAME) --password-stdin $(CONTAINER_REGISTRY)

.PHONY: build
build: is-defined-CONTAINER_REGISTRY is-defined-CONTAINER_SLUG is-defined-CONTAINER_VERSION login
	@docker build --pull -t $(CONTAINER_REGISTRY)/$(CONTAINER_SLUG):$(CONTAINER_VERSION) -f Dockerfile .

.PHONY: run
run: is-defined-CONTAINER_REGISTRY is-defined-CONTAINER_SLUG is-defined-CONTAINER_VERSION build
	@docker run --init --rm -it                                             \
	    --env PORT=$(PORT)                                                  \
	    --publish $(PORT):$(PORT)                                           \
	$(CONTAINER_REGISTRY)/$(CONTAINER_SLUG):$(CONTAINER_VERSION)

.PHONY: push
push: is-defined-CONTAINER_REGISTRY is-defined-CONTAINER_SLUG is-defined-CONTAINER_VERSION build
	@docker push $(CONTAINER_REGISTRY)/$(CONTAINER_SLUG):$(CONTAINER_VERSION)
