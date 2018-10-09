defmodule Parser do
  alias Parser.{Expression, Let, Prefix, Return}

  defstruct [:current, :peek, :tokens, :errors]

  @precedence_levels %{
    lowest: 0
  }

  def from_tokens(tokens) do
    [current | [peek | rest]] = tokens
    %Parser{current: current, peek: peek, tokens: rest, errors: []}
  end

  def parse_program(parser, statements \\ []), do: do_parse_program(parser, statements)

  defp do_parse_program(%Parser{current: %Token.EOF{}} = parser, statements) do
    {parser, %AST.Program{statements: statements |> Enum.reverse}}
  end

  defp do_parse_program(%Parser{current: %Token.Let{}} = parser, statements) do
    {parser, statement} = parse_let_statement(parser)
    statements = add_statement(statement, statements)
    do_parse_program(parser |> IO.inspect |> next_token, statements)
  end

  defp parse_let_statement(%Parser{current: %Token.Let{} = current_token} = parser) do
    with {:ok, parser, ident_token} <- expect_peek(parser, %Token.Ident{}),
         {:ok, parser, assign_token} <- expect_peek(parser, %Token.Assign{}),
         parser <- next_token(parser),
         {:ok, parser, value} <- parse_expression(parser, @precedence_levels.lowest) do

      statement = %AST.LetStatement{
        identifier: %AST.Identifier{ident: ident_token.literal},
        value: value
      }

      {parser |> skip_semicolon, statement}
    end
  end

  defp parse_expression(%Parser{current: %Token.Int{literal: literal} = integer} = parser, _precedence) do
    statement = %AST.Integer{literal: literal, value: literal |> String.to_integer}
    {:ok, parser, statement}
  end

  defp expect_peek(%Parser{peek: peek} = parser, expected_token) do
    if match?(expected_token, peek) do
      {:ok, parser |> next_token, peek}
    else
      {parser, nil}
    end
  end

  defp next_token(%Parser{peek: %Token.EOF{} = peek, tokens: []} = parser) do
    %Parser{
      parser |
      current: peek,
      peek: nil,
      tokens: [],
    }
  end

  defp next_token(%Parser{peek: peek, tokens: tokens} = parser) do
    [next_peek | rest] = tokens
    %Parser{
      parser |
      current: peek,
      peek: next_peek,
      tokens: rest,
    }
  end

  defp skip_semicolon(%Parser{peek: peek} = parser) when peek == %Token.Semicolon{} do
    parser |> next_token
  end

  defp skip_semicolon(%Parser{} = parser), do: parser

  defp add_statement(nil, statements), do: statements
  defp add_statement(statement, statements), do: [statement | statements]

  # defp parse([%Token.Let{} | tokens], statements) do
  #   parse_known_token(Let, tokens, statements)
  # end

  # defp parse([%Token.Return{} | tokens], statements) do
  #   parse_known_token(Return, tokens, statements)
  # end

  # defp parse([%Token.EOF{}], statements), do: {:ok, statements |> Enum.reverse}

  # defp parse(tokens, statements) do
  #   parse_known_token(Expression, tokens, statements)
  # end

  # defp parse_known_token(parser, tokens, statements) do
  #   case parser.parse(tokens) do
  #     {:ok, statement, rest} -> parse(rest, [statement | statements])
  #     {:error, error} -> {:error, error}
  #   end
  # end

  # def show_invalid_tokens(tokens) do
  #   tokens |> Enum.map(&(&1.literal)) |> Enum.reject(&is_nil/1)
  # end

  # def split_until_semicolon(tokens) do
  #   splitter = fn
  #     %Token.Semicolon{} -> false
  #     _ -> true
  #   end
  #   {expression, rest} = Enum.split_while(tokens, splitter)
  #   [_semicolon | rest] = rest
  #   {expression, rest}
  # end
end
