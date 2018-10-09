defmodule Parser.Let do
  def parse([
    %Token.Ident{} = ident,
    %Token.Assign{} | tokens
  ]) do
    {value, rest} = tokens |> Parser.split_until_semicolon
    {:ok,
      %AST.LetStatement{
        identifier: %AST.Identifier{ident: ident.literal},
        value: value
      },
      rest
    }
  end

  def parse(invalid_tokens) do
    {
      :error, """
      invalid let statement, expected an identifier after `let` but instead saw:

      #{inspect(Parser.show_invalid_tokens(invalid_tokens))}
      """
    }
  end
end
