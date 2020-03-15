-module(contact_us_db).

-export([insert_contact_us/3]).

insert_contact_us(Pool, Message, Email) ->
    Now = calendar:local_time(),
    pgapp:equery(Pool,
		 "Insert INTO contact_us(email, message,created"
		 "_at, updated_at) VALUES($1, $2, $3, "
		 "$3)",
		 [Email, Message, Now]).
