defmodule Parser do
  def parse(tokens) do
    parse(tokens, [])
  end

  def parse([%Token.Let{} | tokens], statements) do
    case parse_let_statement(tokens) do
      {:ok, let_statement, rest} -> parse(rest, [let_statement | statements])
      {:error, error} -> { :error, error}
    end
  end

  def parse([%Token.EOF{}], statements), do: {:ok, statements |> Enum.reverse}
  def parse([], _statements), do: raise "unexpected EOF"

  defp parse_let_statement([
    %Token.Ident{} = ident,
    %Token.Assign{} | tokens
  ]) do
    {expression, rest} = tokens |> split_until_semicolon
    {:ok,
      %AST.LetStatement{
        identifier: %AST.Identifier{token: ident},
        expression: expression
      },
      rest
    }
  end

  defp parse_let_statement(invalid_tokens) do
    {
      :error, """
      invalid let statement, expected an identifier after `let` but instead saw:

      #{inspect(show_invalid_tokens(invalid_tokens))}
      """
    }
  end

  defp show_invalid_tokens(tokens) do
    tokens |> Enum.map(&(&1.literal)) |> Enum.reject(&is_nil/1)
  end

  defp split_until_semicolon(tokens) do
    splitter = fn
      %Token.Semicolon{} -> false
      _ -> true
    end
    {expression, rest} = Enum.split_while(tokens, splitter)
    [_semicolon | rest] = rest
    {expression, rest}
  end
end
