defmodule GoodVibesWeb.QuoteLive do
  use GoodVibesWeb, :live_view

  @quotes "priv/quotes.json"
  @default_language "en"
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       title: get_title_by_language(@default_language),
       quote: get_random_quote(@default_language),
       laguage: @default_language
     )}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "quote.html", assigns)
  end

  defp get_random_quote(language) do
    list_name = "#{language}_quotes"

    case get_quotes_list() do
      %{^list_name => [_ | _] = list} -> Enum.random(list)
      _ -> get_empty_message_by_language(language)
    end
  end

  def handle_event("es-language", _, socket) do
    socket = assign(socket, laguage: "es", title: get_title_by_language("es"))

    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_event("en-language", _, socket) do
    socket = assign(socket, laguage: "en", title: get_title_by_language("en"))

    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_event("next-quote", %{"key" => " "}, socket) do
    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_event("next-quote", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("next-quote-button", _, socket) do
    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_info({:get_quote, %{quote: previous_quote, laguage: language}}, socket) do
    case get_random_quote(language) do
      next_quote when next_quote == previous_quote ->
        send(self(), {:get_quote, socket.assigns})

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

  defp get_empty_message_by_language("en"), do: "No quote today"
  defp get_empty_message_by_language("es"), do: "Sin frases para hoy"

  defp get_title_by_language("en"), do: "Your daily quote"
  defp get_title_by_language("es"), do: "Tu frase de hoy"
end
