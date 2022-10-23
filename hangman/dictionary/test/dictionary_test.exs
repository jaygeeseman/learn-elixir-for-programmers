defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  # This test will fail once in awhile
  test "random_word/0 returns random words" do
    assert Dictionary.random_word() != Dictionary.random_word()
  end
end
