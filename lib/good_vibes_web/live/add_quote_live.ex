defmodule GoodVibesWeb.AddQuoteLive do
  use GoodVibesWeb, :live_view

  alias GoodVibes.Spreadsheet.Repo.Http, as: Spreadsheet

  def mount(_params, session, socket) do
    locale =
      case session do
        %{"locale" => locale} -> locale
        _ -> "en"
      end

    Gettext.put_locale(locale)
    {:ok, assign(socket, language: locale, banner: false, x: 0)}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "new_quote_form.html", assigns)
  end

  def handle_event(
        "add-quote",
        %{"new_quote" => %{"name" => name, "new_quote" => new_quote, "country" => country}},
        socket
      ) do
    with :ok <- Spreadsheet.write(name, new_quote, country) do
      {:noreply, assign(socket, banner: true)}
    end

    {:noreply, socket}
  end

  def handle_event("es-language", _, socket) do
    Gettext.put_locale("es")
    socket = assign(socket, language: "es")

    {:noreply, force_rerender(socket)}
  end

  def handle_event("en-language", _, socket) do
    Gettext.put_locale("en")
    socket = assign(socket, language: "en")

    {:noreply, force_rerender(socket)}
  end

  def handle_event("hide-banner", _, socket) do
    {:noreply, assign(socket, :banner, false)}
  end

  defp force_rerender(socket, fingerprint \\ :x) do
    update(socket, fingerprint, &(&1 + 1))
  end
end
