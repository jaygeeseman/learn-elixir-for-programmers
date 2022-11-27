defmodule MemoryWeb.Live.MemoryDisplay do
  use MemoryWeb, :live_view

  # A LiveView page has a mount() callback to initialize it, an update()
  # callback that is called before rendering a response, and a render()
  # callback to do the rendering. Only the render() callback is required.

  def mount(_params, _session, socket) do
    { :ok, schedule_tick_and_update_assign(socket) }
  end

  # Responds to :tick message to update the memory display
  def handle_info(:tick, socket) do
    { :noreply, schedule_tick_and_update_assign(socket) }
  end

  defp schedule_tick_and_update_assign(socket) do
    # Send ourselves a message :tick every 1000ms.
    # As this is called on each update, it creates an infinite update loop.
    Process.send_after(self(), :tick, 1000)
    # Update the memory data
    assign(socket, :memory, :erlang.memory())
  end

  def render(assigns) do
    ~L"""
    <table>
    <%= for { name, value } <- assigns.memory do %>
      <tr>
        <th><%= name %></th>
        <td><%= value %></td>
      </tr>
    <% end %>
    </table>
    """
  end
end
