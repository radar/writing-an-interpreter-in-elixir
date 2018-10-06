defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "processes equals" do
    {:ok, lexer} = Lexer.start_link("=+(){},;")
    [
      %Token.Equals{},
      %Token.Plus{},
      %Token.LParen{},
      %Token.RParen{},
      %Token.LBrace{},
      %Token.RBrace{},
      %Token.Comma{},
      %Token.Semicolon{},
    ]
    |> Enum.each(fn (expected_token) ->
      actual_token = Lexer.next_token(lexer)
      assert actual_token == expected_token
    end)
  end
end
