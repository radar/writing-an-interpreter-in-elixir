defmodule Parser do
  alias Parser.{Let, Return}

  def parse(tokens) do
    parse(tokens, [])
  end

  def parse([%Token.Let{} | tokens], statements) do
    case Let.parse(tokens) do
      {:ok, let_statement, rest} -> parse(rest, [let_statement | statements])
      {:error, error} -> {:error, error}
    end
  end

  def parse([%Token.Return{} | tokens], statements) do
    case Return.parse(tokens) do
      {:ok, return_statement, rest} -> parse(rest, [return_statement | statements])
      {:error, error} -> {:error, error}
    end
  end

  def parse([%Token.EOF{}], statements), do: {:ok, statements |> Enum.reverse}
  def parse([], _statements), do: raise "unexpected EOF"

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
