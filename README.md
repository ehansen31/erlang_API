erlang_api ![Erlang CI](https://github.com/ehansen31/erlang_api/workflows/Erlang%20CI/badge.svg)
=====

Starter for a scalable web service written in Erlang. Goal of the project is to have a boilerplate complete project that can be added on top to meet any number of business requirements from standalone api to a front end integrated server.

| Features |
|:-------------:|
|:-----------------------------------------------------------------|
|pgapp for poolboy and epgsql integration|
|postgres|
|jwt authorization|
|cowboy for endpoints|
|github actions ci w/unit tests|
|database migrations with erlang pure migrations|
|mocks with meck|


| ToDo |
|:-------------:|
|:-----------------------------------------------------------------|
|swagger codegen|
|RabbitMQ integration|
|containerized deployment|

Requirements
=====
rebar3
erlang otp
docker/docker-compose

Infrastructure
-----
    docker-compose up -d

Build
-----
    rebar3 compile
```erlang
r3:compile().
```

Run
-----
    rebar3 run

Shell
-----
    rebar3 shell

Database Migrations
-----
```erlang
migrate_db:migrate().
```

Tests
-----
    rebar3 eunit
```erlang
r3:eunit().
```