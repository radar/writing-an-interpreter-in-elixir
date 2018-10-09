defmodule AST.LetStatement do
  defstruct [:identifier, :expression]
end

defmodule AST.Identifier do
  defstruct [:token]
end
