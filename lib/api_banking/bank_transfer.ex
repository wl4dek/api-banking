defmodule ApiBanking.BankTransfer do
  @moduledoc """
  The BankTransfer context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo

  alias ApiBanking.BankTransfer.Transfer

  @doc """
  Returns the list of transfers.

  ## Examples

      iex> list_transfers()
      [%Transfer{}, ...]

  """
  def list_transfers do
    Repo.all(Transfer)
  end

  @doc """
  Gets a single transfer.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer!(123)
      %Transfer{}

      iex> get_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer!(id), do: Repo.get!(Transfer, id)

  @doc """
  Returns the list of transfers by account id.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer_by_id_account(123)
      [%Transfer{}, ...]

  """
  def get_transfer_by_id_account(id_account) do
    Repo.all(from t in Transfer, where: t.origin == ^id_account or t.destination == ^id_account)
  end

  @doc """
  Returns the list of transfers by day.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer_by_day(12)
      [%Transfer{}, ...]

  """
  def get_transfer_by_day(day, id_account) do
    now = Date.utc_today()
    case day > 0 and day <= now.calendar.days_in_month() do
      true -> Repo.all(from t in Transfer, where: (t.destination == ^id_account  or t.origin == ^id_account) and fragment("Extract(day from ?)", t.inserted_at) == ^day )
      false -> {:error, "Valor do dia invalido"}
    end
  end

  @doc """
  Returns the list of transfers by month.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer_by_month(12)
      [%Transfer{}, ...]

  """
  def get_transfer_by_month(month, id_account) do
    case month > 0 and month <= 12 do
      true -> Repo.all(from t in Transfer, where: (t.destination == ^id_account  or t.origin == ^id_account) and fragment("Extract(month from ?)", t.inserted_at) == ^month)
      false -> {:error, "Valor do mes invalido"}
    end
  end

  @doc """
  Returns the list of transfers by year.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer_by_year(2012)
      [%Transfer{}, ...]

  """
  def get_transfer_by_year(year, id_account) do
    Repo.all(from t in Transfer, where: (t.destination == ^id_account  or t.origin == ^id_account) and fragment("Extract(year from ?)", t.inserted_at) == ^year )
  end

  @doc """
  Creates a transfer.

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(attrs \\ %{}) do
    %Transfer{}
    |> Transfer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> update_transfer(transfer, %{field: new_value})
      {:ok, %Transfer{}}

      iex> update_transfer(transfer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer(%Transfer{} = transfer, attrs) do
    transfer
    |> Transfer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transfer.

  ## Examples

      iex> delete_transfer(transfer)
      {:ok, %Transfer{}}

      iex> delete_transfer(transfer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transfer(%Transfer{} = transfer) do
    Repo.delete(transfer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer changes.

  ## Examples

      iex> change_transfer(transfer)
      %Ecto.Changeset{source: %Transfer{}}

  """
  def change_transfer(%Transfer{} = transfer) do
    Transfer.changeset(transfer, %{})
  end
end
