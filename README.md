# Doist

Currently only the `:unix` executable is supported. 

```
def project do
  [
    …,
    release: release()
  ]
end

defp releases do
  [
    myapp: [
      …,
      include_executables_for: [:unix],
      steps: [
        :assemble, 
        &Doist.commands(&1, commands())
      ]
    ]
  ]
end

defp commands do
  [
    {"migrate", "MyApp.ReleaseTasks.migrate", "Run database migrations"}
  ]
end
```

```
/bin/doist migrate
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `doist` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:doist, "~> 0.1.0", runtime: false}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/doist](https://hexdocs.pm/doist).

