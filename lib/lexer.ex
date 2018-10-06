defmodule Lexer do
  alias Token.{
    Assign,
    Comma,
    EOF,
    Function,
    Ident,
    Illegal,
    Int,
    Let,
    LBrace,
    LParen,
    Plus,
    RBrace,
    RParen,
    Semicolon
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

  def handle_call(:next_token, _from, %{ch: "="} = state) do
    reply(Assign, state)
  end

  def handle_call(:next_token, _from, %{ch: "+"} = state) do
    reply(Plus, state)
  end

  def handle_call(:next_token, _from, %{ch: "("} = state) do
    reply(LParen, state)
  end

  def handle_call(:next_token, _from, %{ch: ")"} = state) do
    reply(RParen, state)
  end

  def handle_call(:next_token, _from, %{ch: ","} = state) do
    reply(Comma, state)
  end

  def handle_call(:next_token, _from, %{ch: ";"} = state) do
    reply(Semicolon, state)
  end

  def handle_call(:next_token, _from, %{ch: "{"} = state) do
    reply(LBrace, state)
  end

  def handle_call(:next_token, _from, %{ch: "}"} = state) do
    reply(RBrace, state)
  end

  def handle_call(:next_token, _from, %{ch: 0} = state) do
    {:reply, EOF, state |> read}
  end

  def handle_call(:next_token, from, %{ch: ch} = state) when ch == " " or ch == "\t" or ch == "\n" do
    new_state = state |> read
    handle_call(:next_token, from, new_state)
  end

  def handle_call(:next_token, _from, %{ch: ch} = state) do
    cond do
      valid_ident_check(ch) ->
        %{ident: ident, state: state} = read_ident(state)
        {:reply, ident, state}
      valid_integer_check(ch) ->
        %{integer: integer, state: state} = read_integer(state)
        {:reply, %Int{literal: integer}, state}
      true ->
        {:reply, %Illegal{literal: ch}, state}
    end
  end

  defp reply(token, state) do
    {:reply, struct(token), state |> read}
  end

  defp read(%{input: input, read_position: read_position} = state) do
    ch = if read_position >= String.length(input), do: 0, else: input |> String.at(read_position)
    %{
      state |
      read_position: read_position + 1,
      ch: ch
    }
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
      new_state = read(state)
      read_while_valid(new_state, value <> ch, validator)
    else
      %{
        value: value,
        state: state
      }
    end
  end

  defp lookup_ident("let"), do: %Let{}
  defp lookup_ident("fn"), do: %Function{}
  defp lookup_ident(ident), do: %Ident{literal: ident}

  defp to_single_char(ch), do: ch |> to_charlist |> List.first
end
