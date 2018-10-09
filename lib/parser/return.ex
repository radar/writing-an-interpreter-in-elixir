defmodule Parser.Return do
  def parse(tokens) do
    {expression, rest} = tokens |> Parser.split_until_semicolon
    {:ok,
      %AST.ReturnStatement{
        expression: expression
      },
      rest
    }
  end
end
