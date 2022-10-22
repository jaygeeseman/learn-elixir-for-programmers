defmodule Dictionary do

  @spec start() :: List.t
  defdelegate start(), to: Dictionary.Impl.WordList

  @spec random_word() :: String.t
  defdelegate random_word(), to: Dictionary.Impl.WordList

  @spec random_word(List.t) :: String.t
  defdelegate random_word(word_list), to: Dictionary.Impl.WordList
end
