ARG DISTRO=fedora
FROM "${DISTRO}" AS base

# Fedora 41 permissions bug: https://github.com/docker/build-push-action/issues/1302#issuecomment-2602511120
RUN chmod 0640 /etc/shadow

# Install dependencies (we use pkg for ease but manual is fine too)
COPY ./scripts/pkg.sh /bin/pkg
RUN pkg install git make sudo curl
RUN pkg install_if2 dnf yum which awk

# Copy over required items
COPY . /dotfiles
WORKDIR /dotfiles

# Non-root user
RUN groupadd -fr sudo
RUN useradd -ms /bin/bash user
RUN usermod -aG sudo user
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chown -R user:user .
USER user

# Build
ARG TARGET=linux
RUN make "${TARGET}"
