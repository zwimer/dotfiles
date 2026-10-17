ARG DISTRO=fedora
FROM "${DISTRO}" AS base

# Copy over required items
COPY . /dotfiles

# Install dependencies (we use pkg for ease but manual is fine too)
RUN /dotfiles/scripts/pkg.sh install git make sudo curl \
 && /dotfiles/scripts/pkg.sh install_if2 dnf yum awk which  # omz sudo plugin assumes awk exists

# Non-root user
RUN groupadd -fr sudo \
 && useradd -ms /bin/bash user \
 && usermod -aG sudo user \
 && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && chown -R user:user /dotfiles
# Fedora docker/PAM permissions bug: https://github.com/docker/build-push-action/issues/1302#issuecomment-2602511120
RUN chmod 0600 /etc/shadow
USER user

# Build
WORKDIR /dotfiles
ARG TARGET=linux
RUN make "${TARGET}"
