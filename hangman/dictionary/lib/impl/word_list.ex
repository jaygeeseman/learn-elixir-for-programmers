defmodule Dictionary.Impl.WordList do

  @type t :: list(String.t())

  @spec word_list(String.t) :: t
  def word_list(filepath) do
    filepath
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec word_list() :: t
  def word_list() do
    word_list("assets/words.txt")
  end

  @spec random_word(t) :: String.t
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
