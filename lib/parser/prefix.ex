defmodule Parser.Prefix do
  def parse([%Token.Bang{} = bang | [next | tokens]]) do
    {:ok,
      %AST.PrefixExpression{
        operator: bang.literal,
        right: Parser.Expression.parse_expression(next)
      },
      tokens
    }
  end
end
