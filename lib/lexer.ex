defmodule Lexer do
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

  use GenServer

  def init(args) do
    {:ok, args |> read}
  end

  def start_link(input) do
    state = %{
      input: input,
      read_position: 0,
      ch: nil,
    }
    GenServer.start_link(__MODULE__, state, [])
  end

  def next_token(lexer) do
    GenServer.call(lexer, :next_token)
  end

  def handle_call(:next_token, from, %{ch: ch} = state) when ch == " " or ch == "\t" or ch == "\n" do
    new_state = state |> read
    handle_call(:next_token, from, new_state)
  end

  def handle_call(:next_token, _from, %{ch: ch} = state) do
    token = case ch do
      "=" -> if peek(state) == "=", do: DoubleEquals, else: Assign
      "!" -> if peek(state) == "=", do: NotEqual, else: Bang
      "+" -> Plus
      "(" -> LParen
      ")" -> RParen
      "{" -> LBrace
      "}" -> RBrace
      "," -> Comma
      ";" -> Semicolon
      "-" -> Minus
      "/" -> Slash
      "*" -> Asterisk
      "<" -> LessThan
      ">" -> GreaterThan
      0 -> EOF
      _ -> nil
    end

    # double character tokens
    case token do
      DoubleEquals -> double_read_and_reply(token, state)
      NotEqual -> double_read_and_reply(token, state)
      nil -> unknown_token(state)
      _ -> read_and_reply(token, state)
    end


  end

  defp unknown_token(%{ch: ch} = state) do
    cond do
      valid_ident_check(ch) ->
        %{ident: ident, state: state} = read_ident(state)
        {:reply, ident, state}
      valid_integer_check(ch) ->
        %{integer: integer, state: state} = read_integer(state)
        reply(Int, integer, state)
      true ->
        reply(Illegal, ch, state)
    end
  end

  defp double_read_and_reply(token, state) do
    {:reply, struct(token), state |> read |> read}
  end

  defp read_and_reply(token, state) do
    {:reply, struct(token), state |> read}
  end

  # Do not advance read here (with `state |> read`)!
  # We have already read a token to the end of the token
  # Advancing will skip the character directly after the token.
  defp reply(token, literal, state) do
    {:reply, struct(token, literal: literal), state}
  end

  defp read(%{read_position: read_position} = state) do
    %{
      state |
      read_position: read_position + 1,
      ch: peek(state)
    }
  end

  defp peek(%{input: input, read_position: read_position}) do
    if read_position >= String.length(input), do: 0, else: input |> String.at(read_position)
  end

  defp valid_ident_check(ch) do
    (ch |> to_single_char) in Enum.to_list(?A..?Z) ++ Enum.to_list(?a..?z) ++ ['_']
  end

  defp read_ident(state) do
    %{value: ident, state: state} = read_while_valid(state, "", &valid_ident_check/1)
    %{ident: lookup_ident(ident), state: state}
  end

  defp valid_integer_check(ch) do
    (ch |> to_single_char) in Enum.to_list(?0..?9)
  end

  defp read_integer(state) do
    %{value: integer, state: state} = read_while_valid(state, "", &valid_integer_check/1)
    %{integer: integer, state: state}
  end

  def read_while_valid(%{ch: ch} = state, value, validator) do
    if validator.(ch) do
      read(state) |> read_while_valid(value <> ch, validator)
    else
      %{
        value: value,
        state: state
      }
    end
  end

  defp lookup_ident("let"), do: %Let{}
  defp lookup_ident("fn"), do: %Function{}
  defp lookup_ident("if"), do: %If{}
  defp lookup_ident("else"), do: %Else{}
  defp lookup_ident("return"), do: %Return{}
  defp lookup_ident("true"), do: %True{}
  defp lookup_ident("false"), do: %False{}

  defp lookup_ident(ident), do: %Ident{literal: ident}

  defp to_single_char(ch), do: ch |> to_charlist |> List.first
end
