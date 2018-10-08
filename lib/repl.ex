defmodule Interpreter.REPL do
  def start do
    IO.puts "Hello! This is the Monkey programming language!"
    IO.puts "Feel free to type in commands"
    prompt()
  end

  def prompt do
    input = IO.gets ">> "
    input |> Lexer.tokenize |> show_token

    prompt()
  end

  def show_token([%Token.EOF{} | []]), do: IO.puts("EOF")
  def show_token([token | rest]) do
    token |> IO.inspect
    show_token(rest)
  end
end
