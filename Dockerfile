####
#
# Build the image with (building for amd64 as Arm runners aren't supported
# yet for OSS projects on GitHub Actions as of June '24):
#
# docker build --platform linux/amd64 -t gunnarmorling/hugo-builder:<yyyymmddd> .
#
# Then run the container using:
#
# docker run --rm -it --rm -it -v $PWD:/src gunnarmorling/hugo-builder:<yyyymmddd> cd /src && hugo -F
#
# Push to Docker Hub:
#
# docker push gunnarmorling/hugo-builder:<yyyymmdd>
#
###
FROM registry.fedoraproject.org/fedora-minimal

RUN microdnf -y install wget ruby tar hugo && microdnf clean all

RUN gem install asciidoctor rouge
