all:
	rm -rf ./apps/openapi/*
	swagger generate -i ./src/handler/swagger.json -g erlang-server -o ./apps/openapi
	swagger generate -i ./src/handler/swagger.json -g html -o ./src/handler/docs