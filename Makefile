current_dir = $(shell pwd)

init:
	melange keygen

build:
	melange build \
		$(package) \
		-r packages/ \
		-k melange.rsa.pub \
		-r https://packages.wolfi.dev/os \
		-k https://packages.wolfi.dev/os/wolfi-signing.rsa.pub \
		--signing-key melange.rsa \
		--arch host
	melange sign-index packages/x86_64/APKINDEX.tar.gz --signing-key melange.rsa

test:
	echo "https://packages.wolfi.dev/os" > repositories
	echo "/packages" >> repositories
	docker \
	run \
	--rm \
	-v $(current_dir)/packages:/packages \
	-v $(current_dir)/repositories:/etc/apk/repositories \
	-v $(current_dir)/melange.rsa.pub:/etc/apk/keys/melange.rsa.pub \
	-p 8000:8000 \
	-it cgr.dev/chainguard/wolfi-base
