defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
    letters:    list(String.t),
    used:       MapSet.t(String.t),
  }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word
      |> new_game
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game = %{ game_state: state }, _guess)
  when state in [:won, :lost] do
    game
    |> game_with_tally
  end

  def make_move(game, guess) do
    validate_guess(guess)
    |> accept_guess(game, MapSet.member?(game.used, guess))
    |> game_with_tally
  end

  @spec tally(t) :: Type.tally
  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: build_tally_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  @spec game_with_tally(t) :: { t, Type.tally }
  defp game_with_tally(game) do
    { game, tally(game) }
  end

  @spec validate_guess(String.t) :: String.t
  defp validate_guess(guess) do
    to_string(guess)
    |> String.first
    |> String.downcase
  end

  @spec accept_guess(String.t, t, any) :: t
  defp accept_guess(_guess, game, _already_used = true) do
    %{ game | game_state: :already_used }
  end

  defp accept_guess(guess, game, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  @spec score_guess(t, any) :: t
  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  defp score_guess(game, _bad_guess) do
    %{ game |
      game_state: maybe_lost(game.turns_left),
      turns_left: game.turns_left - 1
    }
  end

  @spec maybe_won(any) :: Type.state
  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  @spec maybe_lost(integer) :: Type.state
  defp maybe_lost(_turns_left = 1), do: :lost
  defp maybe_lost(_), do: :bad_guess

  @spec build_tally_letters(t) :: List.t
  defp build_tally_letters(game = %{ game_state: :lost }) do
    game.letters
  end

  defp build_tally_letters(game) do
    game.letters
    |> Enum.map(fn letter ->
      Enum.member?(game.used, letter)
      |> tally_letter(letter)
    end)
  end

  @spec tally_letter(any, String.t) :: String.t
  defp tally_letter(_in_word = true, letter), do: letter
  defp tally_letter(_, _letter), do: "_"

end
