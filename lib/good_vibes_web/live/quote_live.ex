defmodule GoodVibesWeb.QuoteLive do
  use GoodVibesWeb, :live_view

  @quotes "priv/quotes.json"
  @default_locale "en"
  @accepted_locales ~w(es en)
  def mount(params, session, socket) do
    locale =
      case fetch_locale(params, session) do
        lang when lang in @accepted_locales -> lang
        _ -> @default_locale
      end

    Gettext.put_locale(locale)
    {:ok, assign(socket, quote: get_random_quote(locale), language: locale, x: 0)}
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
    socket = assign(socket, language: "es")

    send(self(), {:get_quote, socket.assigns})

    {:noreply, force_rerender(socket)}
  end

  def handle_event("en-language", _, socket) do
    Gettext.put_locale("en")
    socket = assign(socket, language: "en")

    send(self(), {:get_quote, socket.assigns})

    {:noreply, force_rerender(socket)}
  end

  def handle_event("next-quote-click", _, socket) do
    send(self(), {:get_quote, socket.assigns})

    {:noreply, socket}
  end

  def handle_info({:get_quote, %{quote: previous_quote, language: language}}, socket) do
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

  defp fetch_locale(%{"language" => lang}, _session), do: lang
  defp fetch_locale(_params, %{"locale" => locale}), do: locale
  defp fetch_locale(_, _), do: nil
end
