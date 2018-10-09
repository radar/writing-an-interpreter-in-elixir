defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "let statements" do
    input = """
    let x = 5;
    let y = 10;
    let foobar = 838383;
    """

    {:ok, statements } = input |> Lexer.tokenize |> Parser.parse

    [first_statement | statements] = statements

    assert first_statement == %AST.LetStatement{
      identifier: %AST.Identifier{token: %Token.Ident{literal: "x"}},
      expression: [%Token.Int{literal: "5"}]
    }

    [second_statement | statements] = statements

    assert second_statement == %AST.LetStatement{
      identifier: %AST.Identifier{token: %Token.Ident{literal: "y"}},
      expression: [%Token.Int{literal: "10"}]
    }

    [third_statement | []] = statements

    assert third_statement == %AST.LetStatement{
      identifier: %AST.Identifier{token: %Token.Ident{literal: "foobar"}},
      expression: [%Token.Int{literal: "838383"}]
    }
  end

  test "failed let statement" do
    input = """
    let 5
    """

    assert input |> Lexer.tokenize |> Parser.parse == {:error, """
      invalid let statement, expected an identifier after `let` but instead saw:

      ["5"]
      """}
  end

  test "return statements" do
    input = """
    return 5;
    return 10;
    return 993322;
    """

    {:ok, statements } = input |> Lexer.tokenize |> Parser.parse

    [first_statement | statements] = statements

    assert first_statement == %AST.ReturnStatement{
      expression: [%Token.Int{literal: "5"}]
    }

    [second_statement | statements] = statements

    assert second_statement == %AST.ReturnStatement{
      expression: [%Token.Int{literal: "10"}]
    }

    [third_statement | []] = statements

    assert third_statement == %AST.ReturnStatement{
      expression: [%Token.Int{literal: "993322"}]
    }
  end
end
