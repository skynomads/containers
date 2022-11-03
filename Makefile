PACKAGES := $(wildcard packages/*.yaml)
CONTAINERS := $(wildcard containers/*.yaml)

# https://github.com/python/cpython/issues/78278
export SOURCE_DATE_EPOCH=631148400

.PHONY: prepare packages containers publish $(PACKAGES) $(CONTAINERS) $(addprefix publish-,$(CONTAINERS))

prepare:
	mkdir -p dist/packages
	mkdir -p dist/containers

packages: $(PACKAGES)

$(PACKAGES): prepare
	melange build --source-dir . --signing-key rsa --keyring-append https://raw.githubusercontent.com/wolfi-dev/os/main/wolfi-signing.rsa.pub --arch x86_64 --out-dir dist/packages $@

containers: $(CONTAINERS)

$(CONTAINERS): prepare
	VERSION=$(shell yq '.package.version' packages/$(notdir $@)); apko build --debug --repository-append "$(shell pwd)/dist/packages" --keyring-append rsa.pub --keyring-append https://raw.githubusercontent.com/wolfi-dev/os/main/wolfi-signing.rsa.pub $@ ghcr.io/skynomads/$(basename $(notdir $@)):$$VERSION dist/$(@:yaml=tar)

publish: $(addprefix publish-,$(CONTAINERS))

$(addprefix publish-,$(CONTAINERS)):
	NAME=$(basename $(notdir $(@:publish-%=%))); \
	VERSION=$(shell yq '.package.version' packages/$(notdir $(@:publish-%=%))); \
	EPOCH=$(shell yq '.package.epoch' packages/$(notdir $(@:publish-%=%))); \
	apko publish --debug --repository-append "$(shell pwd)/dist/packages" --keyring-append rsa.pub $(@:publish-%=%) \
		ghcr.io/skynomads/$$NAME:$$VERSION-$$EPOCH ghcr.io/skynomads/$$NAME:$$VERSION ghcr.io/skynomads/$$NAME:latest

$(addprefix run-,$(CONTAINERS)):
	VERSION=$(shell yq '.package.version' packages/$(notdir $(@:run-%=%))); \
	EPOCH=$(shell yq '.package.epoch' packages/$(notdir $(@:run-%=%))); \
	docker load <
