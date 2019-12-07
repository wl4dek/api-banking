FROM elixir:alpine
RUN apk add inotify-tools
RUN mkdir /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force
# ENV MIX_ENV=prod
ADD . /app
