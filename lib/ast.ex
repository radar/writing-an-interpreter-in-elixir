defmodule AST.Program do
  defstruct [:statements]
end

defmodule AST.LetStatement do
  defstruct [:identifier, :value]
end

defmodule AST.Identifier do
  defstruct [:ident]
end

defmodule AST.Integer do
  defstruct [:value, :literal]
end

defmodule AST.ReturnStatement do
  defstruct [:expression]
end

defmodule AST.ExpressionStatement do
  defstruct [:token, :expression]
end

defmodule AST.PrefixExpression do
  defstruct [:operator, :right]
end

defmodule AST.InfixExpression do
  defstruct [:left, :operator, :right]
end

defmodule AST do
  def output(statements) when is_list(statements) do
    (for statement <- statements, do: output(statement)) |> Enum.join("\n")
  end

  def output(%AST.Identifier{ident: ident}), do: ident

  def output(%AST.LetStatement{identifier: %AST.Identifier{ident: ident}, value: value}) do
    "let #{ident} = #{output(value)};"
  end

  def output(%AST.ReturnStatement{expression: expression}) do
    "return #{expression};"
  end

  def output(%AST.Integer{literal: literal}), do: literal
  def output(%AST.ExpressionStatement{expression: expression}), do: expression
end
