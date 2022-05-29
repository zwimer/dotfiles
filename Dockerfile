ARG DISTRO=fedora
FROM "${DISTRO}" as base

# Install dependencies (we use pkg for ease but manual is fine too)
COPY ./scripts/pkg.sh /bin/pkg
RUN pkg install git make sudo curl
RUN pkg install_if2 dnf yum which

# Copy over required items
COPY . /dotfiles
WORKDIR /dotfiles

ARG TARGET=all
RUN make "${TARGET}"
