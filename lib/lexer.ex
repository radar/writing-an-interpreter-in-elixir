defmodule Lexer do
  defguard is_known_single_token(ch) when
    ch == "=" or
    ch == ";" or
    ch == "(" or
    ch == ")" or
    ch == "{" or
    ch == "}" or
    ch == "," or
    ch == "+" or
    ch == "," or
    ch == "-" or
    ch == "*" or
    ch == "/" or
    ch == "<" or
    ch == ">" or
    ch == "!"

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
    Illegal,
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

  def tokenize(input) when is_binary(input) do
    tokens = input |> String.split("", trim: true) |> tokenize([])
    [%EOF{} | tokens] |> Enum.reverse
  end

  def tokenize(["=" | ["=" | rest]], tokens) do
    tokenize(rest, [struct(DoubleEquals) | tokens])
  end

  def tokenize(["!" | ["=" | rest]], tokens) do
    tokenize(rest, [struct(NotEqual) | tokens])
  end

  def tokenize([ch | rest], tokens) when is_known_single_token(ch) do
    token = case ch do
      "=" -> Assign
      ";" -> Semicolon
      "(" -> LParen
      ")" -> RParen
      "{" -> LBrace
      "}" -> RBrace
      "," -> Comma
      "+" -> Plus
      "!" -> Bang
      "-" -> Minus
      "*" -> Asterisk
      "/" -> Slash
      "<" -> LessThan
      ">" -> GreaterThan
    end
    tokenize(rest, [struct(token, literal: ch) | tokens])
  end

  def tokenize([ch | rest] = chars, tokens) do
    cond do
      whitespace?(ch) -> tokenize(rest, tokens)
      valid_ident?(ch) -> tokenize_ident(chars, tokens)
      valid_number?(ch) -> tokenize_number(chars, tokens)
      true -> tokenize(rest, [%Illegal{literal: ch} | tokens])
    end
  end

  def tokenize([], tokens), do: tokens

  def tokenize_ident(chars, tokens) do
    {ident, rest} = Enum.split_while(chars, &valid_ident?/1)
    tokenize(rest, [ident |> Enum.join |> lookup_ident | tokens])
  end

  def tokenize_number(chars, tokens) do
    {integer, rest} = Enum.split_while(chars, &valid_number?/1)
    tokenize(rest, [struct(Int, literal: integer |> Enum.join) | tokens])
  end

  defp whitespace?(ch) do
    ch == " " or ch == "\n" or ch == "\t"
  end

  def valid_ident?(ch) do
    (ch >= "A" and ch <= "Z") or (ch >= "a" and ch <= "z") or ch == "_"
  end

  def valid_number?(ch) do
    ch >= "0" and ch <= "9"
  end

  defp lookup_ident("let"), do: %Let{}
  defp lookup_ident("fn"), do: %Function{}
  defp lookup_ident("if"), do: %If{}
  defp lookup_ident("else"), do: %Else{}
  defp lookup_ident("return"), do: %Return{}
  defp lookup_ident("true"), do: %True{}
  defp lookup_ident("false"), do: %False{}
  defp lookup_ident(ident), do: %Ident{literal: ident}
end
