FROM alpine:latest as builder
WORKDIR /app
COPY . ./
# This is where one could build the application code as well.


FROM alpine:latest as tailscale
RUN apk update && apk add ca-certificates wget && rm -rf /var/cache/apk/*
WORKDIR /app
ENV TSFILE=tailscale_1.58.2_amd64.tgz
RUN wget --inet4-only https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1


# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:latest
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY --from=builder /app/start.sh /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Run on container startup.
CMD ["/app/start.sh"]
