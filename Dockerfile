FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.21 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src
COPY . .

RUN CGO_ENABLED=0 GOOS=${PLATFORM} GOARCH=${ARCH} go build -o app

FROM scratch
COPY --from=builder /src/app .
ENTRYPOINT ["./app"]
