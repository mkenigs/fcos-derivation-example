# Build a small Go program
FROM registry.ci.openshift.org/openshift/release:golang-1.17 as builder
WORKDIR /build
COPY . .
RUN go build hello-world.go

FROM quay.io/cgwalters/fcos
# Inject it into Fedora CoreOS
COPY --from=builder /build/hello-world /usr/bin
# And add our unit file
ADD hello-world.service /etc/systemd/system/hello-world.service
# Also add strace; rm -rf /var/cache currently is needed to avoid
# errors in the output since the dnf cache is attemped to be copied.
# We will address this issue in the future.
RUN rpm-ostree install strace && rm -rf /var/cache 
