defmodule GoodVibesWeb.AddQuoteLive do
  use GoodVibesWeb, :live_view

  def mount(_params, session, socket) do
    locale =
      case session do
        %{"locale" => locale} -> locale
        _ -> "en"
      end

    Gettext.put_locale(locale)
    {:ok, assign(socket, laguage: locale, new_quote: "")}
  end

  def render(assigns) do
    Phoenix.View.render(GoodVibesWeb.QuoteView, "new_quote_form.html", assigns)
  end
end
