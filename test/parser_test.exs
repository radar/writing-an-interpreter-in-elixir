defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "let statements" do
    input = """
    let x = 5;
    let y = 10;
    let foobar = 838383;
    """

    {_parser, %AST.Program{statements: statements}} = input
    |> Lexer.tokenize
    |> Parser.from_tokens
    |> Parser.parse_program

    [first_statement | statements] = statements

    assert first_statement == %AST.LetStatement{
      identifier: %AST.Identifier{ident: "x"},
      value: %AST.Integer{literal: "5", value: 5}
    }

    [second_statement | statements] = statements

    assert second_statement == %AST.LetStatement{
      identifier: %AST.Identifier{ident: "y"},
      value: %AST.Integer{literal: "10", value: 10}
    }

    [third_statement | []] = statements

    assert third_statement == %AST.LetStatement{
      identifier: %AST.Identifier{ident: "foobar"},
      value: %AST.Integer{literal: "838383", value: 838383}
    }
  end

  test "failed let statement" do
    input = """
    let 5
    """

    {%Parser{errors: errors}, _program} = input
    |> Lexer.tokenize
    |> Parser.from_tokens
    |> Parser.parse_program

    [error | []] = errors
    assert error == "expected to see Token.Ident, but instead saw Token.Int"
  end

  test "return statements" do
    input = """
    return 5;
    return 10;
    return 993322;
    """

    {_parser, %AST.Program{statements: statements}} = input
    |> Lexer.tokenize
    |> Parser.from_tokens
    |> Parser.parse_program

    [first_statement | statements] = statements

    assert first_statement == %AST.ReturnStatement{
      expression: %AST.Integer{literal: "5", value: 5}
    }

    [second_statement | statements] = statements

    assert second_statement == %AST.ReturnStatement{
      expression: %AST.Integer{literal: "10", value: 10}
    }

    [third_statement | []] = statements

    assert third_statement == %AST.ReturnStatement{
      expression: %AST.Integer{literal: "993322", value: 993322}
    }
  end

  test "ident expressions" do
    input = """
    foobar;
    """

    {_parser, %AST.Program{statements: [first_statement | []]}} = input
    |> Lexer.tokenize
    |> Parser.from_tokens
    |> Parser.parse_program

    assert first_statement == %AST.Identifier{ident: "foobar"}
  end

  test "integer expressions" do
    input = """
    5;
    """

    {_parser, %AST.Program{statements: [first_statement | []]}} = input
    |> Lexer.tokenize
    |> Parser.from_tokens
    |> Parser.parse_program

    assert first_statement == %AST.Integer{literal: "5", value: 5}
  end

  # test "prefix expressions" do
  #   input = """
  #   !5
  #   """

  #   {:ok, [first_statement | []]} = input |> Lexer.tokenize |> Parser.parse

  #   assert first_statement == %AST.PrefixExpression{
  #     operator: "!",
  #     right: %AST.Integer{
  #       literal: "5", value: 5
  #     }
  #   }
  # end

  # test "infix +" do
  #   input = """
  #   5 + 5
  #   """

  #   # input |> Lexer.tokenize |> Parser.parse |> IO.inspect

  #   # assert first_statement == %AST.InfixExpression{
  #   #   left: %AST.Integer{
  #   #     literal: "5", value: 5
  #   #   },
  #   #   operator: "+",
  #   #   right: %AST.Integer{
  #   #     literal: "5", value: 5
  #   #   }
  #   # }
  # end
end
