defmodule GoodVibes.Spreadsheet.Repo.Http do
  @moduledoc """
  Http adapter for the Spreadsheet.
  """

  require Logger

  @columns "A:C"

  alias GSS.Spreadsheet

  def start_link(_opts \\ []), do: :ignore

  def fetch do
    with {:ok, pid} <- spreadsheet(),
         {:ok, file} <- Spreadsheet.fetch(pid, @columns) do
      {:ok, file}
    else
      error ->
        {:error, error}
    end
  end

  def write(name, new_quote, country) do
    with {:ok, pid} <- spreadsheet(),
         :ok <- Spreadsheet.write_row(pid, get_next_empty_row, [name, new_quote, country]) do
      :ok
    else
      error ->
        {:error, error}
    end
  end

  def get_next_empty_row() do
    with {:ok, [_head | quotes]} <- fetch() do
      length(quotes) + 2
    end
  end

  defp spreadsheet(opts \\ []) do
    :good_vibes
    |> Application.get_env(__MODULE__)
    |> Keyword.get(:spreadsheet_id)
    |> Spreadsheet.Supervisor.spreadsheet(opts)
  end
end
