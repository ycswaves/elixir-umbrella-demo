defmodule Counter1Test do
  use ExUnit.Case
  doctest Counter1

  test "greets the world" do
    assert Counter1.hello() == :world
  end
end
