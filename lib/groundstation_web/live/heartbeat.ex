defmodule GroundStationWeb.Heartbeat do
  use Phoenix.LiveView

  @default "#888888"
  @active "#FF0000"
  def render(assigns) do
    ~L"""
    <svg width="22px" height="25px" viewBox="0 0 22 25" xmlns="http://www.w3.org/2000/svg">
      <title>heart</title>
        <path
          d="M10.8580986,24.4921875 C10.4601549,22.9964682 9.89069236,21.5865337 9.1496938,20.2623419 C8.40869524,18.93815 6.9953303,16.890143 4.90955658,14.1182595 C3.37267068,12.0873746 2.41899239,10.7906466 2.04849311,10.2280366 C1.4584387,9.33609385 1.03305702,8.51963546 0.772335308,7.7786369 C0.511613592,7.03763834 0.38125469,6.28292891 0.38125469,5.51448596 C0.38125469,4.08737762 0.854663335,2.89699501 1.80149483,1.94330242 C2.74832632,0.989609833 3.92155644,0.51277069 5.32122038,0.51277069 C6.70716213,0.51277069 7.91469723,1.00676232 8.94386189,1.9947604 C9.72602704,2.74948115 10.3640996,3.85410133 10.8580986,5.30865405 C11.3109311,3.68943498 12.027905,2.48189988 13.009042,1.68601254 C13.990179,0.890125202 15.0776467,0.4921875 16.2714777,0.4921875 C17.6574194,0.4921875 18.8306495,0.965596145 19.7912032,1.91242764 C20.7517569,2.85925913 21.2320266,3.97760129 21.2320266,5.26748767 C21.2320266,6.43387429 20.9541563,7.63454839 20.3984073,8.86954599 C19.8426584,10.1045436 18.7551907,11.7443214 17.1359717,13.7889285 C15.0501979,16.42359 13.5785146,18.499041 12.7208773,20.0153436 C11.8632401,21.5316462 11.2423201,23.0239126 10.8580986,24.4921875 Z"
          id="♥"
          fill="<%= assigns.color %>"
        ></path>
    </svg>
    """
  end

  def mount(_session, socket) do
    MAVLink.Router.subscribe(message: APM.Message.Heartbeat)
    {:ok, set_default(socket)}
  end

  def handle_info(heartbeat = %APM.Message.Heartbeat{}, socket) do
    # IO.inspect(heartbeat)
    {:noreply, pulse_active(socket)}
  end

  def handle_info(:set_default, socket) do
    {:noreply, set_default(socket)}
  end

  defp set_default(socket) do
    assign(socket, color: @default)
  end

  @short_time 500

  defp pulse_active(socket) do
    Process.send_after(self(), :set_default, @short_time)
    assign(socket, color: @active)
  end
end
