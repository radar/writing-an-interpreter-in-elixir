defmodule Parser do
  # alias Parser.{Expression, Let, Prefix, Return}

  defstruct [:current, :peek, :tokens, :errors]

  @precedence_levels %{
    lowest: 0
  }

  def from_tokens(tokens) do
    [current | [peek | rest]] = tokens
    %Parser{current: current, peek: peek, tokens: rest, errors: []}
  end

  def parse_program(parser, statements \\ []), do: do_parse_program(parser, statements)

  defp do_parse_program(%Parser{errors: errors} = parser) when length(errors) > 0 do
    {parser, nil}
  end

  defp do_parse_program(%Parser{current: %Token.EOF{}} = parser, statements) do
    {parser, %AST.Program{statements: statements |> Enum.reverse}}
  end

  defp do_parse_program(%Parser{current: %Token.Let{}} = parser, statements) do
    parser |> parse_let_statement |> handle_statement(statements)
  end

  defp do_parse_program(%Parser{current: %Token.Return{}} = parser, statements) do
    parser |> parse_return_statement |> handle_statement(statements)
  end

  defp do_parse_program(%Parser{current: %Token.Ident{}} = parser, statements) do
    parser |> parse_ident_statement |> handle_statement(statements)
  end

  defp do_parse_program(%Parser{current: %Token.Int{}} = parser, statements) do
    {:ok, parser, statement} = parser |> parse_expression(@precedence_levels.lowest)
    {:ok, parser |> next_token, statement} |> handle_statement(statements)
  end

  defp parse_let_statement(%Parser{current: %Token.Let{}} = parser) do
    with {:ok, parser, ident_token} <- expect_peek(parser, Token.Ident),
         {:ok, parser, _assign_token} <- expect_peek(parser, Token.Assign),
         parser <- next_token(parser),
         {:ok, parser, value} <- parse_expression(parser, @precedence_levels.lowest) do

      statement = %AST.LetStatement{
        identifier: %AST.Identifier{ident: ident_token.literal},
        value: value
      }

      {:ok, parser |> skip_semicolon, statement}
    else
      error -> error
    end
  end

  defp parse_return_statement(%Parser{current: %Token.Return{}} = parser) do
    with parser <- next_token(parser),
         {:ok, parser, value} <- parse_expression(parser, @precedence_levels.lowest) do

      statement = %AST.ReturnStatement{
        expression: value
      }

      {:ok, parser |> skip_semicolon, statement}
    else
      error -> error
    end
  end

  defp parse_ident_statement(%Parser{current: %Token.Ident{literal: ident}} = parser) do
    statement = %AST.Identifier{
      ident: ident
    }
    {:ok, parser |> skip_semicolon, statement}
  end

  defp parse_expression(%Parser{current: %Token.Int{literal: literal}} = parser, _precedence) do
    statement = %AST.Integer{literal: literal, value: literal |> String.to_integer}
    {:ok, parser, statement}
  end

  defp expect_peek(%Parser{peek: peek} = parser, expected_token) do
    case peek do
      %^expected_token{} -> {:ok, parser |> next_token, peek}
      _ ->
      error = "expected to see #{inspect(expected_token)}, but instead saw #{inspect(peek.__struct__)}"
      {:error, error, parser}
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

  defp handle_statement({:ok, parser, statement}, statements) do
    statements = add_statement(statement, statements)
    do_parse_program(parser |> next_token, statements)
  end

  defp handle_statement({:error, error, parser}, _statements) do
    do_parse_program(%Parser{parser | errors: [error | parser.errors]})
  end

  defp add_statement(nil, statements), do: statements
  defp add_statement(statement, statements), do: [statement | statements]
end
