defmodule Interpreter.REPL do
  @prompt ">>"

  def start do
    IO.puts "Hello! This is the Monkey programming language!"
    IO.puts "Feel free to type in commands"
  end

  def prompt do
    input = IO.gets ">> "
    {:ok, lexer} = Lexer.start_link(input)
    show_tokens(lexer)

    prompt()
  end

  defp show_tokens(lexer) do
    lexer |> Lexer.next_token |> show_token(lexer)
  end

  def show_token(%Token.EOF{}, _lexer), do: IO.puts("EOF")
  def show_token(token, lexer) do
    token |> IO.inspect
    lexer |> show_tokens
  end
end
