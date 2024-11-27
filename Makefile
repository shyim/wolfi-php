current_dir = $(shell pwd)
ARCH ?= $(shell uname -m)
ifeq (${ARCH}, arm64)
	ARCH = aarch64
endif
TARGETDIR = packages/${ARCH}
MELANGE ?= $(shell which melange)

MELANGE_OPTS += --repository-append packages/
MELANGE_OPTS += --keyring-append melange.rsa.pub
MELANGE_OPTS += --signing-key melange.rsa
MELANGE_OPTS += --arch ${ARCH}
MELANGE_OPTS += --repository-append https://packages.wolfi.dev/os
MELANGE_OPTS += --keyring-append https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
MELANGE_OPTS += --repository-append https://wolfi.shyim.me
MELANGE_OPTS += --keyring-append https://wolfi.shyim.me/php-signing.rsa.pub
MELANGE_OPTS += --git-repo-url=https://github.com/shyim/wolfi.php
MELANGE_OPTS += --git-commit=$(shell git rev-parse HEAD)
MELANGE_OPTS += ${MELANGE_EXTRA_OPTS}

MELANGE_TEST_OPTS += --repository-append packages/
MELANGE_TEST_OPTS += --keyring-append melange.rsa.pub
MELANGE_TEST_OPTS += --arch ${ARCH}
MELANGE_TEST_OPTS += --repository-append https://packages.wolfi.dev/os
MELANGE_TEST_OPTS += --keyring-append https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
MELANGE_TEST_OPTS += --repository-append https://wolfi.shyim.me
MELANGE_TEST_OPTS += --keyring-append https://wolfi.shyim.me/php-signing.rsa.pub
MELANGE_TEST_OPTS += --test-package-append wolfi-base
MELANGE_TEST_OPTS += --debug
MELANGE_TEST_OPTS += ${MELANGE_EXTRA_OPTS}

clean:
	rm -rf packages/${ARCH}

init:
	melange keygen

package/%:
	$(eval yamlfile := $*.yaml)
	@if [ -z "$(yamlfile)" ]; then \
		echo "Error: could not find yaml file for $*"; exit 1; \
	else \
		echo "yamlfile is $(yamlfile)"; \
	fi
	$(eval pkgver := $(shell $(MELANGE) package-version $(yamlfile)))
	@printf "Building package $* with version $(pkgver) from file $(yamlfile)\n"
	$(MAKE) yamlfile=$(yamlfile) pkgname=$* packages/$(ARCH)/$(pkgver).apk

packages/$(ARCH)/%.apk: $(KEY)
	@mkdir -p ./$(pkgname)/
	$(eval SOURCE_DATE_EPOCH ?= $(shell git log -1 --pretty=%ct --follow $(yamlfile)))
	$(info @SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) $(MELANGE) build $(yamlfile) $(MELANGE_OPTS) --source-dir ./$(pkgname)/)
	@SOURCE_DATE_EPOCH=$(SOURCE_DATE_EPOCH) $(MELANGE) build $(yamlfile) $(MELANGE_OPTS) --source-dir ./$(pkgname)/

build:
	@mkdir -p ./$(package)/
	melange build \
		$(package).yaml \
		-r packages/ \
		-k melange.rsa.pub \
		-r https://packages.wolfi.dev/os \
		-k https://packages.wolfi.dev/os/wolfi-signing.rsa.pub \
		--signing-key melange.rsa \
		--git-repo-url=https://github.com/shyim/wolfi.php \
		--git-commit=$(shell git rev-parse HEAD) \
		--source-dir ./$(package)/ \
		--arch ${ARCH}

test/%:
	@mkdir -p ./$(*)/
	$(eval yamlfile := $*.yaml)
	@if [ -z "$(yamlfile)" ]; then \
		echo "Error: could not find yaml file for $*"; exit 1; \
	else \
		echo "yamlfile is $(yamlfile)"; \
	fi
	$(eval pkgver := $(shell $(MELANGE) package-version $(yamlfile)))
	@printf "Testing package $* with version $(pkgver) from file $(yamlfile)\n"
	$(MELANGE) test $(yamlfile) $(MELANGE_TEST_OPTS) --source-dir ./$(*)/

shell:
	echo "https://packages.wolfi.dev/os" > repositories
	echo "/packages" >> repositories
	docker \
	run \
	--rm \
	-v $(current_dir)/packages:/packages \
	-v $(current_dir)/repositories:/etc/apk/repositories \
	-v $(current_dir)/melange.rsa.pub:/etc/apk/keys/melange.rsa.pub \
	-it cgr.dev/chainguard/wolfi-base
