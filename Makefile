PACKAGES := $(wildcard packages/*.yaml)
CONTAINERS := $(wildcard containers/*.yaml)

.PHONY: packages $(PACKAGES) $(CONTAINERS)

prepare:
	mkdir -p dist/packages
	mkdir -p dist/containers

packages: $(PACKAGES)

$(PACKAGES): prepare
	melange build --signing-key rsa --arch x86_64 --out-dir dist/packages $@

containers: $(CONTAINERS)

$(CONTAINERS): prepare
	VERSION=$(shell yq '.package.version' packages/$(notdir $@)); apko build --debug --keyring-append rsa.pub $@ $(basename $(notdir $@)):$$VERSION dist/$(@:yaml=tar)