all:
	swagger generate -i ./src/swagger/.swagger-codegen/swagger.json -l erlang-server -o ./src/swagger