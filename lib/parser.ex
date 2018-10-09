defmodule Parser do
  alias Parser.{Expression, Let, Prefix, Return}

  @precedence [
    LOWEST,
    EQUALS,
    LESSGREATER,
    SUM,
    PRODUCT,
    PREFIX,
    CALL
  ]

  def parse(tokens) do
    parse(tokens, [])
  end

  defp parse([%Token.Let{} | tokens], statements) do
    parse_known_token(Let, tokens, statements)
  end

  defp parse([%Token.Return{} | tokens], statements) do
    parse_known_token(Return, tokens, statements)
  end

  defp parse([%Token.Bang{} = bang | tokens], statements) do
    parse_known_token(Prefix, [bang | tokens], statements)
  end

  defp parse([%Token.EOF{}], statements), do: {:ok, statements |> Enum.reverse}
  defp parse(tokens, statements) do
    parse_known_token(Expression, tokens, statements)
  end

  defp parse_known_token(parser, tokens, statements) do
    case parser.parse(tokens) do
      {:ok, statement, rest} -> parse(rest, [statement | statements])
      {:error, error} -> {:error, error}
    end
  end

  def show_invalid_tokens(tokens) do
    tokens |> Enum.map(&(&1.literal)) |> Enum.reject(&is_nil/1)
  end

  def split_until_semicolon(tokens) do
    splitter = fn
      %Token.Semicolon{} -> false
      _ -> true
    end
    {expression, rest} = Enum.split_while(tokens, splitter)
    [_semicolon | rest] = rest
    {expression, rest}
  end
end
