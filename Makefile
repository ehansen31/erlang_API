all:
	swagger generate -i ./src/handlers/swagger.json -l erlang-server -o ./apps/swagger
	swagger generate -i ./src/handlers/swagger.json -l html -o ./src/handlers/docs