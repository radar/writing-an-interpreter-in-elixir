defmodule Token.EOF do
  defstruct []
end

defmodule Token.Illegal do
  defstruct [:literal]
end

defmodule Token.Assign do
  defstruct [literal: "="]
end

defmodule Token.Plus do
  defstruct [literal: "+"]
end

defmodule Token.LParen do
  defstruct [literal: "("]
end

defmodule Token.RParen do
  defstruct [literal: ")"]
end

defmodule Token.LBrace do
  defstruct [literal: "{"]
end

defmodule Token.RBrace do
  defstruct [literal: "}"]
end

defmodule Token.Comma do
  defstruct [literal: ","]
end

defmodule Token.Semicolon do
  defstruct [literal: ";"]
end

defmodule Token.Let do
  defstruct [literal: "let"]
end

defmodule Token.Function do
  defstruct [literal: "fn"]
end

defmodule Token.Ident do
  defstruct [:literal]
end

defmodule Token.Int do
  defstruct [:literal]
end

