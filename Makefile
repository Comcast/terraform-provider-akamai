NAME=terraform-provider-akamai
VERSION=0.2.2

all: updatedeps test install

updatedeps:
	@go tool cover 2>/dev/null; if [ $$? -eq 3 ]; then \
		go get -u golang.org/x/tools/cmd/cover; \
	fi
	go get -u github.com/mitchellh/gox
	go get -u github.com/aktau/github-release
	go get -u github.com/kardianos/govendor
	govendor sync

test:
	go test $(TEST) -cover
	TF_LOG=DEBUG TF_ACC=1 go test -v

cover:
	go test $(TEST) -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

install:
	cd bin/${NAME} \
		&& go install

build: updatedeps
	cd bin/${NAME} \
		&& rm -rf build \
		&& gox -ldflags "-X main.version=${VERSION}" \
			-os "linux darwin windows" \
			-arch "386 amd64" \
			-output "build/{{.OS}}_{{.Arch}}/${NAME}"

package:
	rm -rf release
	mkdir release
	for f in bin/$(NAME)/build/*; do \
		g=`basename $$f`; \
		tar -zcf release/$(NAME)-$${g}-$(VERSION).tgz -C bin/$(NAME)/build/$${g} .; \
	done

release: package
	github-release release \
		--user Comcast \
		--repo ${NAME} \
		--target $(shell git rev-parse --abbrev-ref HEAD) \
		--tag ${VERSION} \
		--name "Release: ${VERSION}"
	ls release/*.tgz | xargs -I FILE github-release upload \
		--user Comcast \
		--repo ${NAME} \
		--tag ${VERSION} \
		--name FILE \
		--file FILE
