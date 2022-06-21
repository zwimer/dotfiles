ARG DISTRO=fedora
FROM "${DISTRO}" as base

# Install dependencies (we use pkg for ease but manual is fine too)
COPY ./scripts/pkg.sh /bin/pkg
RUN pkg install git make sudo curl
RUN pkg install_if2 dnf yum which

# Copy over required items
COPY . /dotfiles
WORKDIR /dotfiles

# Non-root user (fedora uses the wheel group instead of sudo)
RUN useradd -ms /bin/bash user
RUN usermod -aG wheel user
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R user:user .
USER user

# Build
ARG TARGET=all
RUN make "${TARGET}"
