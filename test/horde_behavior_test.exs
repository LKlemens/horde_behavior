defmodule HordeBehaviorTest do
  use ExUnit.Case
  doctest HordeBehavior

  test "greets the world" do
    assert HordeBehavior.hello() == :world
  end
end
