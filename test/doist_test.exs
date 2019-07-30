defmodule DoistTest do
  use ExUnit.Case
  doctest Doist

  test "greets the world" do
    assert Doist.hello() == :world
  end
end
