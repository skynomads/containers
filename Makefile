PACKAGES := $(wildcard packages/*.yaml)
CONTAINERS := $(wildcard containers/*.yaml)

.PHONY: prepare packages containers publish $(PACKAGES) $(CONTAINERS) $(addprefix publish-,$(CONTAINERS))

prepare:
	mkdir -p dist/packages
	mkdir -p dist/containers

packages: $(PACKAGES)

$(PACKAGES): prepare
	melange build --signing-key rsa --keyring-append wolfi-signing.rsa.pub --arch x86_64 --out-dir dist/packages $@

containers: $(CONTAINERS)

$(CONTAINERS): prepare
	VERSION=$(shell yq '.package.version' packages/$(notdir $@)); apko build --debug --keyring-append rsa.pub $@ ghcr.io/skynomads/$(basename $(notdir $@)):$$VERSION dist/$(@:yaml=tar)

publish: $(addprefix publish-,$(CONTAINERS))

$(addprefix publish-,$(CONTAINERS)):
	VERSION=$(shell yq '.package.version' packages/$(notdir $(@:publish-%=%))); apko publish --debug --keyring-append rsa.pub $(@:publish-%=%) ghcr.io/skynomads/$(basename $(notdir $(@:publish-%=%))):$$VERSION