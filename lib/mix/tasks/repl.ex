defmodule Mix.Tasks.Repl do
  use Mix.Task

  def run(_args) do
    Interpreter.REPL.start
  end
end
