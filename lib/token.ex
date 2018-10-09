defmodule Token.EOF do
  defstruct [:literal]
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

defmodule Token.Bang do
  defstruct [literal: "!"]
end

defmodule Token.Minus do
  defstruct [literal: "-"]
end

defmodule Token.Asterisk do
  defstruct [literal: "*"]
end

defmodule Token.Slash do
  defstruct [literal: "/"]
end

defmodule Token.LessThan do
  defstruct [literal: "<"]
end

defmodule Token.GreaterThan do
  defstruct [literal: ">"]
end

## Double character tokens

defmodule Token.DoubleEquals do
  defstruct [literal: "=="]
end

defmodule Token.NotEqual do
  defstruct [literal: "!="]
end

# Keywords

defmodule Token.Let do
  defstruct [literal: "let"]
end

defmodule Token.Function do
  defstruct [literal: "fn"]
end

defmodule Token.If do
  defstruct [literal: "if"]
end

defmodule Token.Else do
  defstruct [literal: "else"]
end

defmodule Token.Return do
  defstruct [literal: "return"]
end

defmodule Token.True do
  defstruct [literal: "true"]
end

defmodule Token.False do
  defstruct [literal: "false"]
end

# Special identifiers + values

defmodule Token.Ident do
  defstruct [:literal]
end

defmodule Token.Int do
  defstruct [:literal]
end

