defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  alias Token.{
    Assign,
    Comma,
    Function,
    Ident,
    Int,
    Let,
    LBrace,
    LParen,
    Plus,
    RBrace,
    RParen,
    Semicolon
  }

  test "processes equals" do
    {:ok, lexer} = """
    let five = 5;
    let ten = 10;
    let add = fn(x, y) {
    x + y;
    };
    let result = add(five, ten);
    """
    |> Lexer.start_link
    [
      %Let{},
      %Ident{literal: "five"},
      %Assign{},
      %Int{literal: "5"},
      %Semicolon{},

      %Let{},
      %Ident{literal: "ten"},
      %Assign{},
      %Int{literal: "10"},
      %Semicolon{},

      %Let{},
      %Ident{literal: "add"},
      %Assign{},
      %Function{},
      %LParen{},
      %Ident{literal: "x"},
      %Comma{},
      %Ident{literal: "y"},
      %RParen{},
      %LBrace{},

      %Ident{literal: "x"},
      %Plus{},
      %Ident{literal: "y"},
      %Semicolon{},

      %RBrace{},
      %Semicolon{},

      %Let{},
      %Ident{literal: "result"},
      %Assign{},
      %Ident{literal: "add"},
      %LParen{},
      %Ident{literal: "five"},
      %Comma{},
      %Ident{literal: "ten"},
      %RParen{},
      %Semicolon{}
    ]
    |> Enum.each(fn (expected_token) ->
      actual_token = Lexer.next_token(lexer)
      assert actual_token == expected_token
    end)
  end
end
