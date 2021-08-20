defmodule GoodVibesWeb.QuoteLive do
  use GoodVibesWeb, :live_view

  @quotes "priv/quotes.json"
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :quote, get_random_quote())}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "quote.html", assigns)
  end

  defp get_random_quote() do
    case get_quotes_list() do
      %{"life_quotes" => list} -> Enum.random(list)
      _ -> "No quote today"
    end
  end

  def handle_event("next-quote", %{"key" => " "}, socket) do
    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_event("next-quote", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("next-quote-button", _, socket) do
    socket = assign(socket, :quote, get_random_quote())
    {:noreply, socket}
  end

  def handle_info({:get_quote, %{quote: previous_quote}}, socket) do
    case get_random_quote() do
      next_quote when next_quote == previous_quote ->
        send(self(), {:get_quote, previous_quote})

        {:noreply, socket}

      next_quote ->
        socket = assign(socket, :quote, next_quote)
        {:noreply, socket}
    end
  end

  defp get_quotes_list do
    @quotes
    |> File.read!()
    |> Jason.decode!()
  end
end
