defmodule ApiBanking.Saques do
  @moduledoc """
  The Saques context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo

  alias ApiBanking.Saques.Saque

  @doc """
  Returns the list of saques.

  ## Examples

      iex> list_saques_by_day(12)
      [%Saque{}, ...]

  """
  def list_saques_by_day(day, id_account) do
    now = Date.utc_today()
    case day > 0 and day <= now.calendar.days_in_month() do
      true -> Repo.all(from s in Saque, where: s.origin == ^id_account and fragment("Extract(day from ?)", s.inserted_at) == ^day )
      false -> {:error, "Valor do dia invalido"}
    end
  end

  @doc """
  Returns the list of saques.

  ## Examples

      iex> list_saques_by_month(5)
      [%Saque{}, ...]

  """
  def list_saques_by_month(month, id_account) do
    case month > 0 and month <= 12 do
      true -> Repo.all(from s in Saque, where: s.origin == ^id_account and fragment("Extract(month from ?)", s.inserted_at) == ^month )
      false -> {:error, "Valor do mes invalido"}
    end
  end

  @doc """
  Returns the list of saques.

  ## Examples

      iex> list_saques_by_year(2012)
      [%Saque{}, ...]

  """
  def list_saques_by_year(year, id_account) do
    Repo.all(from s in Saque, where: s.origin == ^id_account and fragment("Extract(year from ?)", s.inserted_at) == ^year )
  end

  @doc """
  Gets a single saque.

  Raises `Ecto.NoResultsError` if the Saque does not exist.

  ## Examples

      iex> get_saque!(123)
      %Saque{}

      iex> get_saque!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saque!(id), do: Repo.get!(Saque, id)

  @doc """
  Creates a saque.

  ## Examples

      iex> create_saque(%{field: value})
      {:ok, %Saque{}}

      iex> create_saque(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saque(attrs \\ %{}) do
    %Saque{}
    |> Saque.changeset(attrs)
    |> Repo.insert()
  end

end
