defmodule TextClient do

  def start() do
    TextClient.Runtime.RemoteHangman.connect()
  |> TextClient.Impl.Player.start()
  end

end
