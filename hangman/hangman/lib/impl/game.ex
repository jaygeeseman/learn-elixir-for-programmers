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
    |> return_with_tally
  end

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  @spec tally(t) :: Type.tally
  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: build_tally_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  @spec return_with_tally(t) :: { t, Type.tally }
  defp return_with_tally(game) do
    { game, tally(game) }
  end

  @spec accept_guess(t, String.t, true) :: t
  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end

  @spec accept_guess(t, String.t, any) :: t
  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  @spec score_guess(t, true) :: t
  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  @spec score_guess(t, any) :: t
  defp score_guess(game, _bad_guess) do
    # turns_left == 1 -> lost | decrement turns_left, :bad_guess
    %{ game |
      game_state: maybe_lost(game.turns_left),
      turns_left: game.turns_left - 1
    }
  end

  @spec maybe_won(true) :: Type.state
  defp maybe_won(true), do: :won
  @spec maybe_won(any) :: Type.state
  defp maybe_won(_), do: :good_guess

  @spec maybe_lost(1) :: Type.state
  defp maybe_lost(_turns_left = 1), do: :lost
  @spec maybe_lost(integer) :: Type.state
  defp maybe_lost(_), do: :bad_guess

  defp build_tally_letters(game) do
    game.letters
    |> Enum.map(&tally_letter(&1, Enum.member?(game.used, &1)))
    # |> Enum.map(fn letter -> Enum.member?(game.used, letter) |> &tally_letter(letter) end)
  end

  defp tally_letter(letter, _in_word = true), do: letter
  defp tally_letter(_letter, _), do: "_"
  # defp tally_letter(_in_word = true, letter), do: letter
  # defp tally_letter(_, _letter), do: "_"

end
