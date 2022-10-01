FROM gitpod/workspace-elixir:latest

ARG USERNAME=gitpod

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
    sudo apt-get install -y zsh

RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -

RUN sudo apt-get update && \
    sudo apt-get install -y nodejs

RUN gem install htmlbeautifier

COPY setup-container.sh .
RUN bash ./setup-container.sh

ENV MIX_HOME=/home/gitpod/.mix
ENV HEX_HOME=/home/gitpod/.hex

RUN mix local.hex --force && \
    mix local.rebar --force
