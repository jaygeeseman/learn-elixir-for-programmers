defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "start/0 returns a list of words" do
    word_list = Dictionary.start()
    assert Enum.count(word_list) > 0
    Enum.each(word_list, fn x -> assert String.length(x) > 0 end)
  end

  test "random_word/0 returns random words" do
    assert Dictionary.random_word() != Dictionary.random_word()
  end

  test "random_word/1 returns a random word from the given list" do
    word_list = Dictionary.start()
    assert Enum.member?(word_list, Dictionary.random_word(word_list))

    word_list = ["notaword"]
    assert Enum.member?(word_list, Dictionary.random_word(word_list))
  end
end
