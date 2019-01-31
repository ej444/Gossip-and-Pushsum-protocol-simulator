defmodule Pro2Test do
  use ExUnit.Case
  doctest Pro2

  test "greets the world" do
    assert Pro2.hello() == :world
  end
end
