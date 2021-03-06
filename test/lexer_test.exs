defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  alias Token.{
    Assign,
    Asterisk,
    Bang,
    Comma,
    DoubleEquals,
    EOF,
    Else,
    False,
    Function,
    GreaterThan,
    Ident,
    If,
    Int,
    LessThan,
    Let,
    LBrace,
    LParen,
    Minus,
    NotEqual,
    Plus,
    RBrace,
    Return,
    RParen,
    Semicolon,
    Slash,
    True,
  }

  test "processes some example Monkey code" do
    actual_tokens = """
    let five = 5;
    let ten = 10;
    let add = fn(x, y) {
    x + y;
    };
    let result = add(five, ten);
    """
    |> Lexer.tokenize


    expected_tokens = [
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
      %Semicolon{},
      %EOF{},
    ]

    assert expected_tokens == actual_tokens
  end

  test "1.4: Extending our Token Set and Lexer" do
    actual_tokens = """
    !-/*5;
    5 < 10 > 5;

    if (5 < 10) {
      return true;
    } else {
      return false;
    }

    10 == 10;
    10 != 9;
    """ |> Lexer.tokenize

    expected_tokens = [
      %Bang{},
      %Minus{},
      %Slash{},
      %Asterisk{},
      %Int{literal: "5"},
      %Semicolon{},

      %Int{literal: "5"},
      %LessThan{},
      %Int{literal: "10"},
      %GreaterThan{},
      %Int{literal: "5"},
      %Semicolon{},

      %If{},
      %LParen{},
      %Int{literal: "5"},
      %LessThan{},
      %Int{literal: "10"},
      %RParen{},
      %LBrace{},

      %Return{},
      %True{},
      %Semicolon{},

      %RBrace{},
      %Else{},
      %LBrace{},

      %Return{},
      %False{},
      %Semicolon{},
      %RBrace{},

      %Int{literal: "10"},
      %DoubleEquals{},
      %Int{literal: "10"},
      %Semicolon{},

      %Int{literal: "10"},
      %NotEqual{},
      %Int{literal: "9"},
      %Semicolon{},
      %EOF{},
    ]

    assert expected_tokens == actual_tokens
  end
end
