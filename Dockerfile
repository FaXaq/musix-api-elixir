FROM elixir:1.4.2

RUN mkdir /musix
WORKDIR /musix
COPY . /musix
RUN mix local.hex --force
RUN mix deps.get
RUN mix phoenix.server

EXPOSE 4000
