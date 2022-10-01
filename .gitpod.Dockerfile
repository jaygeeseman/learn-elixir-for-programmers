FROM gitpod/workspace-elixir:2022-09-26-11-35-42

ARG USERNAME=gitpod

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y vim && \
    apt-get install -y git && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    apt-get install -y rubygems && \
    apt-get install -y rename && \
    apt-get install -y zsh

RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -

RUN apt-get update && \
    apt-get install -y nodejs

RUN gem install htmlbeautifier

COPY setup-container.sh .
RUN bash ./setup-container.sh

ENV MIX_HOME=/root/.mix
ENV HEX_HOME=/root/.hex

RUN mix local.hex --force && \
    mix local.rebar --force
