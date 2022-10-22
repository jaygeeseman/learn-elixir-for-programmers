defmodule Dictionary.Impl.WordList do

  @spec start() :: List.t
  def start() do
    word_list()
  end

  @spec word_list(String.t) :: List.t
  def word_list(filepath) do
    filepath
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec word_list() :: List.t
  def word_list() do
    word_list("assets/words.txt")
  end

  @spec random_word(List.t) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end

  @spec random_word() :: String.t
  def random_word do
    word_list()
    |> random_word()
  end

end
