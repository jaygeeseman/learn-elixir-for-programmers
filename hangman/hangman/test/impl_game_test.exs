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

  test "make_move/2 state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat") |> Map.put(:game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "make_move/2 records guessed letters properly" do
    game = Game.new_game("wombat")
    { game, _tally } = Game.make_move(game, "x")
    { game, _tally } = Game.make_move(game, "y")
    { game, _tally } = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "make_move/2 reports a duplicate guess appropriately" do
    { game, _tally } = Game.new_game("wombat") |> Game.make_move("x")
    refute game.game_state == :already_used
    { game, _tally } = Game.make_move(game, "y")
    refute game.game_state == :aready_used
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game.game_state == :already_used
    assert game.used == new_game.used
  end

end
