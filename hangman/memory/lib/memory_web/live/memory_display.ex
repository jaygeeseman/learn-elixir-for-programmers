defmodule MemoryWeb.Live.MemoryDisplay do
  use MemoryWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :memory, :erlang.memory())
    { :ok, socket }
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
