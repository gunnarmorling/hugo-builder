####
#
# Build and push the multi-arch image (linux/amd64 for x64 GitHub Actions runners,
# linux/arm64 for Arm runners and Apple Silicon) with:
#
# docker buildx build --platform linux/amd64,linux/arm64 -t gunnarmorling/hugo-builder:<yyyymmdd> --push .
#
# For a local single-arch build instead, use:
#
# docker build -t gunnarmorling/hugo-builder:<yyyymmdd> .
#
# Then run the container using:
#
# docker run --rm -v $PWD:/src gunnarmorling/hugo-builder:<yyyymmdd> bash -c "cd /src && hugo -F"
#
# To upgrade Hugo, update HUGO_VERSION and the checksums below from the release's
# hugo_<version>_checksums.txt.
#
###
FROM registry.fedoraproject.org/fedora-minimal

ARG TARGETARCH
ARG HUGO_VERSION=0.168.0
ARG HUGO_SHA256_AMD64=fada83ad56bb27ed4cb7dd81590303bdac16140f944ac4e66fc248117e2d5594
ARG HUGO_SHA256_ARM64=91ce984e998a955a3dc1b5852eb4e65d0ed0f6d12a5c51690df97a548e1fdeeb

RUN microdnf -y install wget ruby tar gzip && microdnf clean all

RUN case "${TARGETARCH}" in \
      amd64) HUGO_SHA256="${HUGO_SHA256_AMD64}" ;; \
      arm64) HUGO_SHA256="${HUGO_SHA256_ARM64}" ;; \
      *) echo "Unsupported architecture: '${TARGETARCH}'" >&2; exit 1 ;; \
    esac \
    && wget -q -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-${TARGETARCH}.tar.gz \
    && echo "${HUGO_SHA256}  /tmp/hugo.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo \
    && rm /tmp/hugo.tar.gz \
    && hugo version

ARG ASCIIDOCTOR_VERSION=2.0.23
ARG ROUGE_VERSION=4.3.0

RUN gem install asciidoctor -v "${ASCIIDOCTOR_VERSION}" && gem install rouge -v "${ROUGE_VERSION}"
