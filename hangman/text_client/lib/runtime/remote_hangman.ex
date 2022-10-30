defmodule TextClient.Runtime.RemoteHangman do

  @remote_server :"one@jaygeeseman-learnelixir-085hgojkjq7"

  def connect() do
    :rpc.call(
      @remote_server,
      Hangman,
      :new_game,
      []
    )
  end

end
