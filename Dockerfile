ARG DISTRO=fedora
FROM "${DISTRO}" as base


WORKDIR /dotfiles
COPY ./scripts ./scripts

RUN ./scripts/pkg.sh init
RUN ./scripts/pkg.sh install git make sudo curl
RUN ./scripts/pkg.sh install_if2 dnf yum which

COPY ./.gitmodules ./.gitmodules
COPY ./delayed_rm ./delayed_rm
COPY ./Makefile ./Makefile
COPY ./conf ./conf
COPY ./.git ./.git

ARG TARGET=all
RUN make "${TARGET}"
