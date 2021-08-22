defmodule GoodVibesWeb.QuoteLive do
  use GoodVibesWeb, :live_view

  @quotes "priv/quotes.json"
  def mount(_params, session, socket) do
    locale =
      case session do
        %{"locale" => locale} -> locale
        _ -> "en"
      end

    Gettext.put_locale(locale)
    {:ok, assign(socket, quote: get_random_quote(locale), laguage: locale, x: 0)}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "quote.html", assigns)
  end

  defp get_random_quote(language) do
    list_name = "#{language}_quotes"

    case get_quotes_list() do
      %{^list_name => [_ | _] = list} -> Enum.random(list)
      _ -> gettext("No quote today")
    end
  end

  def handle_event("es-language", _, socket) do
    Gettext.put_locale("es")
    socket = assign(socket, laguage: "es")

    send(self(), {:get_quote, socket.assigns})

    {:noreply, force_rerender(socket)}
  end

  def handle_event("en-language", _, socket) do
    Gettext.put_locale("en")
    socket = assign(socket, laguage: "en")

    send(self(), {:get_quote, socket.assigns})

    {:noreply, force_rerender(socket)}
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

  defp force_rerender(socket, fingerprint \\ :x) do
    update(socket, fingerprint, &(&1 + 1))
  end
end
