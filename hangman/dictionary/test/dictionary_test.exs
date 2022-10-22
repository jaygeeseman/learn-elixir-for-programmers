defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  # This test will fail once in awhile
  test "random_word/0 returns random words" do
    { :ok, pid } = Dictionary.start_link()
    assert Dictionary.random_word(pid) != Dictionary.random_word(pid)
  end
end
