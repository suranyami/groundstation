defmodule GroundStationWeb.AltitudeLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <svg viewBox="0 0 100 50" xmlns="http://www.w3.org/2000/svg">
      <text
        x="50" y="10" fill="#888"
        class="label"
        text-anchor="middle"
        alignment-baseline="middle"
        dominant-baseline="central">
        ALTITUDE
      </text>

      <text
        x="50" y="25" fill="#ccc"
        class="value-text"
        text-anchor="middle"
        alignment-baseline="middle"
        dominant-baseline="central">
        <%= @value %> m
      </text>
    </svg>
    """
  end

  def mount(_session, socket) do
    MAVLink.Router.subscribe(message: APM.Message.VfrHud)
    {:ok, put_value(socket, 0)}
  end

  def handle_info(%APM.Message.VfrHud{alt: altitude}, socket) do
    alt_string =
      altitude
      |> Float.round(1)
      |> Float.to_string()

    {:noreply, put_value(socket, alt_string)}
  end

  defp put_value(socket, value) do
    assign(socket, value: value)
  end
end
