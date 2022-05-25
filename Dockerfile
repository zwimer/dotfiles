ARG DISTRO=fedora

# Base images

FROM ubuntu:22.04 as ubuntu_base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -yq
RUN apt-get install -yq git make sudo
ENV MAKEF="Makefile.apt"

FROM fedora:36 as fedora_base
RUN dnf upgrade -yq
RUN dnf install -yq git make sudo
ENV MAKEF="Makefile.dnf"

# Images

FROM ${DISTRO}_base as setup
COPY . /dotfiles
WORKDIR /dotfiles

FROM setup as test
ARG TARGET=all
RUN make -f "${MAKEF}" "${TARGET}"
