ARG golang_version=1.19-alpine3.17
ARG alpine_version=3.17

FROM golang:${golang_version} AS builder
ARG golang_version

COPY . /build
WORKDIR /build
RUN go build -o /go/bin/gin-ping src/main.go

FROM alpine:${alpine_version}
ARG alpine_version

COPY --from=builder /go/bin/gin-ping /go/bin/gin-ping

ENTRYPOINT ["/go/bin/gin-ping"]
