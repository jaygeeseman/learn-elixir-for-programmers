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

end
