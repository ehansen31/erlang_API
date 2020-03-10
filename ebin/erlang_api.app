{application, 'erlang_api', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['erlang_api_app','erlang_api_sup','hello_handler']},
	{registered, [erlang_api_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {erlang_api_app, []}},
	{env, []}
]}.