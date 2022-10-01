FROM gitpod/workspace-elixir:latest

ARG USERNAME=gitpod

# apt-get update fails without getting the public key store
RUN sudo curl -s https://packages.erlang-solutions.com/debian/erlang_solutions.asc | sudo apt-key add -

RUN sudo apt-get update && \
    sudo apt-get install -y postgresql-client && \
    sudo apt-get install -y inotify-tools && \
    sudo apt-get install -y vim && \
    sudo apt-get install -y git && \
    sudo apt-get install -y curl && \
    sudo apt-get install -y wget && \
    sudo apt-get install -y gnupg2 && \
    sudo apt-get install -y rubygems && \
    sudo apt-get install -y rename && \
    sudo apt-get install -y zsh && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y erlang && \
    sudo apt-get install -y erlang-dialyzer

RUN sudo curl -sL https://deb.nodesource.com/setup_16.x  | sudo bash -

RUN sudo apt-get update && \
    sudo apt-get install -y nodejs

# Cleanup apt-get
RUN sudo apt-get autoremove -y && \
    sudo apt-get clean -y && \
    sudo rm -rf /var/lib/apt/lists/*

ENV MIX_HOME=/home/gitpod/.mix
ENV HEX_HOME=/home/gitpod/.hex

RUN mix local.hex --force && \
    mix local.rebar --force
