defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "random_word returns random words" do
    assert Dictionary.random_word() != Dictionary.random_word()
  end
end
