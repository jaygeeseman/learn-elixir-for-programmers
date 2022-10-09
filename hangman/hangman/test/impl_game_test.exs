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

  test "make_move/2 reports a duplicate guess appropriately" do
    { game, tally } = Game.new_game("wombat") |> Game.make_move("x")
    refute tally.game_state == :already_used
    { game, tally } = Game.make_move(game, "y")
    refute tally.game_state == :aready_used
    { _new_game, new_tally } = Game.make_move(game, "x")
    assert new_tally.game_state == :already_used
    assert tally.used == new_tally.used
  end

  test "make_move/2 records good guesses and a win properly" do
    { game, tally } = Game.new_game("wombat") |> Game.make_move("w")
    assert tally.turns_left == 7
    assert tally.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "o")
    { game, _tally } = Game.make_move(game, "m")
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "a")
    { _game, tally } = Game.make_move(game, "t")
    assert tally.turns_left == 7
    assert tally.game_state == :won
  end

  test "make_move/2 records bad guesses and loss properly" do
    game = Game.new_game("wombat")
    { game, tally } = Game.make_move(game, "z")
    assert tally.turns_left == 6
    assert tally.game_state == :bad_guess
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "v")
    { game, _tally } = Game.make_move(game, "u")
    { game, tally } = Game.make_move(game, "s")
    assert tally.turns_left == 1
    assert tally.game_state == :bad_guess
    { _game, tally } = Game.make_move(game, "r")
    assert tally.game_state == :lost
  end

  test "make_move/2 can handle a sequence of moves" do
    # wombat, win
    [
      [ "x", :bad_guess,  6, [ "_", "_", "_", "_", "_", "_" ], [ "x" ]],
      [ "a", :good_guess, 6, [ "_", "_", "_", "_", "a", "_" ], [ "a", "x" ]],
      [ "t", :good_guess, 6, [ "_", "_", "_", "_", "a", "t" ], [ "a", "t", "x" ]],
      [ "w", :good_guess, 6, [ "w", "_", "_", "_", "a", "t" ], [ "a", "t", "w", "x" ]],
      [ "o", :good_guess, 6, [ "w", "o", "_", "_", "a", "t" ], [ "a", "o", "t", "w", "x" ]],
      [ "m", :good_guess, 6, [ "w", "o", "m", "_", "a", "t" ], [ "a", "m", "o", "t", "w", "x" ]],
      [ "c", :bad_guess,  5, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "m", "o", "t", "w", "x" ]],
      [ "d", :bad_guess,  4, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "m", "o", "t", "w", "x" ]],
      [ "e", :bad_guess,  3, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "m", "o", "t", "w", "x" ]],
      [ "f", :bad_guess,  2, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "f", "m", "o", "t", "w", "x" ]],
      [ "g", :bad_guess,  1, [ "w", "o", "m", "_", "a", "t" ], [ "a", "c", "d", "e", "f", "g", "m", "o", "t", "w", "x" ]],
      [ "b", :won,        1, [ "w", "o", "m", "b", "a", "t" ], [ "a", "c", "d", "e", "f", "g", "m", "o", "t", "w", "x" ]]
    ]
    |> test_sequence_of_moves
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("wombat")
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
