defmodule Doist do
  import Mix.Generator

  @type command :: {name :: String.t(), eval :: String.t(), desc :: String.t()}

  @spec commands(%Mix.Release{}, [command]) :: %Mix.Release{}
  def commands(release, commands) do
    commands_list = Enum.map_join(commands, ", ", &elem(&1, 0))
    info(release, [:green, "* adding commands ", :reset, commands_list])

    if :unix in release.options[:include_executables_for] do
      cli_path = Path.join([release.path, "bin", "doist"])
      File.write(cli_path, cli_template(release: release, commands: commands))
      executable!(cli_path)
    end

    release
  end

  defp info(release, message) do
    unless release.options[:quiet] do
      Mix.shell().info(message)
    end
  end

  defp executable!(path), do: File.chmod!(path, 0o744)

  embed_template(:cli, ~S"""
  #!/bin/sh
  set -e
  SELF=$(readlink "$0" || true)
  if [ -z "$SELF" ]; then SELF="$0"; fi
  BIN="$(cd "$(dirname "$SELF")" && pwd -P)"
  case $1 in
  <%= for {name, eval, _desc} <- @commands do %>
    <%= name %>)
      exec "$BIN/<%= @release.name %>" eval "<%= eval %>"
      ;;
  <% end %>
    *)
      echo "Usage: $(basename "$0") COMMAND
  The known commands are:
  <%= for {name, _eval, desc} <- @commands do %>
      <%= String.pad_trailing(name, 8) %>    <%= desc %><% end %>
  " >&2
      if [ -n "$1" ]; then
        echo "ERROR: Unknown command $1" >&2
        exit 1
      fi
      ;;
  esac
  """)
end
