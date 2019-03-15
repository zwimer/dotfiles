FROM ubuntu:18.04

# Packages
RUN apt-get update --fix-missing
RUN apt-get install -y make git sudo

# Set up
RUN git clone https://github.com/zwimer/dotfiles

# cd on start
CMD cd dotfiles && git pull && /bin/bash
