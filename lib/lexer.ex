defmodule Lexer do
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
    {:reply, %Token.Equals{}, state |> read }
  end

  def handle_call(:next_token, _from, %{ch: "+"} = state) do
    {:reply, %Token.Plus{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: "("} = state) do
    {:reply, %Token.LParen{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: ")"} = state) do
    {:reply, %Token.RParen{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: ","} = state) do
    {:reply, %Token.Comma{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: ";"} = state) do
    {:reply, %Token.Semicolon{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: "{"} = state) do
    {:reply, %Token.LBrace{}, state |> read}
  end

  def handle_call(:next_token, _from, %{ch: "}"} = state) do
    {:reply, %Token.RBrace{}, state |> read}
  end

  defp read(%{input: input, read_position: read_position} = state) do
    ch = if read_position >= String.length(input), do: 0, else: input |> String.at(read_position)
    %{
      state |
      read_position: read_position + 1,
      ch: ch
    }
  end
end
