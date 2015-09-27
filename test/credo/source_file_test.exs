defmodule Credo.SourceFileTest do
  use Credo.TestHelper

  test "it should NOT report expected code" do
"""
defmodule CredoSampleModule do
  def some_function(parameter1, parameter2) do
    some_value = parameter1 + parameter2
  end
end
""" |> Credo.SourceFile.parse("example.ex")
    |> refute_issues
  end

  test "it should report a violation" do
"""
defmodule CredoSampleModule do
  def some_function(parameter1, parameter2) do
    someValue = parameter1 +
end
""" |> Credo.SourceFile.parse("example.ex")
    |>  assert_issue(fn(issue) ->
          assert :error == issue.category
          assert issue.message |> String.starts_with?("missing terminator")
        end)
  end

  test "it should return line and column correctly" do
    source_file = """
defmodule CredoSampleModule do
  def some_function(parameter1, parameter2) do
    some_value = parameter1 + parameter2
  end
end
""" |> to_source_file

    assert "    some_value = parameter1 + parameter2" ==
           Credo.SourceFile.line_at(source_file, 3)
    assert 17 == Credo.SourceFile.column(source_file, 3, :parameter1)
    assert 0  == Credo.SourceFile.column(source_file, 1, :defmodule)
  end

end
