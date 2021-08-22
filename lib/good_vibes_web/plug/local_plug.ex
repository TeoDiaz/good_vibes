defmodule GoodVibesWeb.Plugs.Locale do
  @default "en"

  def init(_opts), do: nil

  def call(conn, _opts) do
    with :error <- conn |> req_header_locale("accept-language") |> check() do
      Gettext.put_locale(@default)
      Plug.Conn.put_session(conn, "locale", @default)
    else
      {:ok, loc} ->
        Gettext.put_locale(loc)
        Plug.Conn.put_session(conn, "locale", loc)
    end
  end

  defp req_header_locale(conn, header) do
    case Plug.Conn.get_req_header(conn, header) do
      [language | _] ->
        Regex.scan(~r/[a-z-]{2,8}/i, language)
        |> List.flatten()

      _ ->
        nil
    end
  end

  defp check([h | t]) do
    case check(h) do
      {:ok, loc} -> {:ok, loc}
      :error -> check(t)
    end
  end

  defp check(nil), do: :error
  defp check([]), do: :error

  defp check(<<lang::binary-size(2)>>) do
    {:ok, String.downcase(lang)}
  end

  defp check(<<lang::binary-size(2), "-", _region::binary-size(2)>>) do
    {:ok, String.downcase(lang)}
  end

  defp check(_), do: :error
end
