defmodule InterpreterTest do
  use ExUnit.Case
  doctest Interpreter

  test "greets the world" do
    assert Interpreter.hello() == :world
  end
end
