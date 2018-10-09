defmodule ASTTest do
  use ExUnit.Case

  test "let statement stringification" do
    output = [
      %AST.LetStatement{
        identifier: %AST.Identifier{
          ident: "myVar"
        },
        value: %AST.Identifier{
          ident: "anotherVar"
        }
      },
    ] |> AST.output

    assert output == "let myVar = anotherVar;"
  end

  test "integer stringification" do
    output = [
      %AST.Integer{
        value: 5,
        literal: "5",
      }
    ] |> AST.output

    assert output == "5"
  end

  test "prefix expression stringification" do
    raise "todo"
  end
end
