defmodule Token.Equals do
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
