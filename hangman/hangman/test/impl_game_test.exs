defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new_game/0 returns structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new_game/0 letters property is an array of characters" do
    game = Game.new_game()
    Enum.each(game.letters, fn entry ->
      assert is_binary(entry)
      assert String.length(entry) == 1
    end)
  end

  test "new_game/1 returns correct word" do
    game = Game.new_game("wombat")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "tally/1 returns appropriate tally" do
    # Too lazy to DRY this up
    game = Game.new_game("wombat")
    tally = Game.tally(game)
    assert tally.turns_left == game.turns_left
    assert tally.game_state == game.game_state
    assert tally.letters == ["_", "_", "_", "_", "_", "_"]
    assert tally.used == MapSet.to_list(game.used)

    { game, _tally } = Game.make_move(game, "w")
    tally = Game.tally(game)
    assert tally.turns_left == game.turns_left
    assert tally.game_state == game.game_state
    assert tally.letters == ["w", "_", "_", "_", "_", "_"]
    assert tally.used == MapSet.to_list(game.used)
  end

  test "make_move/2 state doesn't change if a game is already won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat") |> Map.put(:game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "make_move/2 records guessed letters properly" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "x") # bad guess
    { game, _tally } = Game.make_move(game, "y") # bad guess
    { game, _tally } = Game.make_move(game, "x") # duplicate
    { game, _tally } = Game.make_move(game, "w") # good guess
    assert MapSet.equal?(game.used, MapSet.new(["w", "x", "y"]))
  end

  test "make_move/2 can handle a complete winning game" do
    # wombat, win
    [
      [ "x", :bad_guess,    6, [ "_", "_", "_", "_", "_", "_" ], [ "x" ]],
      [ "a", :good_guess,   6, [ "_", "_", "_", "_", "a", "_" ], [ "a", "x" ]],
      [ "t", :good_guess,   6, [ "_", "_", "_", "_", "a", "t" ], [ "a", "t", "x" ]],
      [ "w", :good_guess,   6, [ "w", "_", "_", "_", "a", "t" ], [ "a", "t", "w", "x" ]],
      [ "o", :good_guess,   6, [ "w", "o", "_", "_", "a", "t" ], [ "a", "o", "t", "w", "x" ]],
      [ "m", :good_guess,   6, [ "w", "o", "m", "_", "a", "t" ], [ "a", "m", "o", "t", "w", "x" ]],
      [ "m", :already_used, 6, [ "w", "o", "m", "_", "a", "t" ], [ "a", "m", "o", "t", "w", "x" ]],
      [ "c", :bad_guess,    5, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "m", "o", "t", "w", "x" ]],
      [ "c", :already_used, 5, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "m", "o", "t", "w", "x" ]],
      [ "d", :bad_guess,    4, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "m", "o", "t", "w", "x" ]],
      [ "e", :bad_guess,    3, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "m", "o", "t", "w", "x" ]],
      [ "f", :bad_guess,    2, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "f", "m", "o", "t", "w", "x" ]],
      [ "g", :bad_guess,    1, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "f", "g", "m", "o", "t", "w", "x" ]],
      [ "b", :won,          1, [ "w", "o", "m", "b", "a", "t" ], [ "a", "b", "c", "d", "e", "f", "g", "m", "o", "t", "w", "x" ]]
    ]
    |> test_sequence_of_moves("wombat")
  end

  test "make_move/2 can handle a complete losing game" do
    # hello, lose
    [
      [ "h", :good_guess,   7, [ "h", "_", "_", "_", "_" ], [ "h" ]],
      [ "l", :good_guess,   7, [ "h", "_", "l", "l", "_" ], [ "h", "l" ]],
      [ "a", :bad_guess,    6, [ "h", "_", "l", "l", "_" ], [ "a", "h", "l" ]],
      [ "e", :good_guess,   6, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "l" ]],
      [ "i", :bad_guess,    5, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "l" ]],
      [ "p", :bad_guess,    4, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "l", "p" ]],
      [ "j", :bad_guess,    3, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "j", "l", "p" ]],
      [ "k", :bad_guess,    2, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "j", "k", "l", "p" ]],
      [ "m", :bad_guess,    1, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "j", "k", "l", "m", "p" ]],
      [ "m", :already_used, 1, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "j", "k", "l", "m", "p" ]],
      [ "n", :lost,         0, [ "h", "e", "l", "l", "_" ], [ "a", "e", "h", "i", "j", "k", "l", "m", "n", "p" ]],
    ]
    |> test_sequence_of_moves("hello")
  end

  def test_sequence_of_moves(script, word) do
    game = Game.new_game(word)
    Enum.reduce(script, game, &check_one_move/2)
  end

  def check_one_move([ guess, state, turns, letters, used ], game) do
    { game, tally } = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end
