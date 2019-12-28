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

      iex> list_saques()
      [%Saque{}, ...]

  """
  def list_saques do
    Repo.all(Saque)
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

  @doc """
  Updates a saque.

  ## Examples

      iex> update_saque(saque, %{field: new_value})
      {:ok, %Saque{}}

      iex> update_saque(saque, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saque(%Saque{} = saque, attrs) do
    saque
    |> Saque.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Saque.

  ## Examples

      iex> delete_saque(saque)
      {:ok, %Saque{}}

      iex> delete_saque(saque)
      {:error, %Ecto.Changeset{}}

  """
  def delete_saque(%Saque{} = saque) do
    Repo.delete(saque)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saque changes.

  ## Examples

      iex> change_saque(saque)
      %Ecto.Changeset{source: %Saque{}}

  """
  def change_saque(%Saque{} = saque) do
    Saque.changeset(saque, %{})
  end
end
