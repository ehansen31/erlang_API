#!/usr/bin/expect -f

set timeout -1

spawn rebar3 shell

expect "===> Booted erlang_api"

send -- "\r"

send -- "migrate_db:migrate().\r"

expect "ok"