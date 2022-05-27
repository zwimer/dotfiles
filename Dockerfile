ARG DISTRO=fedora
FROM "${DISTRO}" as base


WORKDIR /dotfiles
COPY ./scripts ./scripts

RUN ./scripts/prep_install.sh
RUN ./scripts/install.sh git make sudo curl
RUN ./scripts/install_if.sh dnf yum which

COPY ./.gitmodules ./.gitmodules
COPY ./delayed_rm ./delayed_rm
COPY ./Makefile ./Makefile
COPY ./conf ./conf
COPY ./.git ./.git

ARG TARGET=all
RUN make "${TARGET}"
