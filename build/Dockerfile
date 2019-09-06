FROM golang:1.10-alpine3.8 AS builder

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOARCH amd64
ENV GOFLAGS "-gcflags all=-trimpath=${GOPATH} -asmflags all=-trimpath=${GOPATH}"

WORKDIR /go/src/gamepod.cc/agent

COPY . /go/src/gamepod.cc/agent

RUN go build $GOFLAGS -o /go/bin/gamepod-operator gamepod.cc/agent

FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

ENV OPERATOR=/usr/local/bin/gamepod-operator \
    USER_UID=1001 \
    USER_NAME=gamepod-operator

# install operator binary
# COPY build/_output/bin/gamepod-operator ${OPERATOR}
COPY --from=builder /go/bin/gamepod-operator ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}
