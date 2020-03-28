all:
	swagger generate -i ./src/swagger/priv/swagger.json -l erlang-server -o ./src/swagger