all:
	swagger generate -i /home/erik/workspace/erlang_api/src/handler/swagger.json -g erlang-server -o ./apps/openapi
	# swagger generate -i ./src/handlers/swagger.json -l html -o ./src/handlers/docs