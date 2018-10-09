defmodule Parser.Expression do
  def parse(tokens) do
    {expression, rest} = tokens |> Parser.split_until_semicolon
    {:ok, expression |> List.first |> parse_expression, rest}
  end

  def parse_expression(%Token.Ident{literal: ident}) do
    %AST.Identifier{ident: ident}
  end

  def parse_expression(%Token.Int{literal: literal}) do
    %AST.Integer{literal: literal, value: literal |> String.to_integer}
  end
end
