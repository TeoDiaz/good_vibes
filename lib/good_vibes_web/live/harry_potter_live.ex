defmodule GoodVibesWeb.HarryPotterLive do
  use GoodVibesWeb, :live_view

  @quotes "priv/quotes.json"
  def mount(_params, _session, socket) do
    {:ok, assign(socket, quote: get_random_quote())}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "quote.html", assigns)
  end

  defp get_random_quote do
    case get_quotes_list() do
      %{"harry_potter_quotes" => list} -> Enum.random(list)
      _ -> "No quote today"
    end
  end

  defp get_quotes_list do
    @quotes
    |> File.read!()
    |> Jason.decode!()
  end
end
