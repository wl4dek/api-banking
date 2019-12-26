defmodule ApiBanking.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ApiBanking.Repo

  alias ApiBanking.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by Email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_email('fulando@email.com')
      %User{}

      iex> get_user_by_email('xxx@email.com')
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^String.downcase(email))
  end

  @doc """
  validate password user.

  Raises `Ecto.NoResultsError` if the password User does not mach.

  ## Examples

      iex> check_password(user, args)
      %User{}

      iex> check_password(user, args)
      ** (Ecto.NoResultsError)

  """
  def check_password(user, password) do
    case user do
      nil ->
        {:error, "Usuario não encontrado"}
      _ ->
        Bcrypt.verify_pass(password, user.password)
    end
  end

  @doc """
  find_and_confirm_password login

  Raises `Ecto.NoResultsError` if the User have access.

  ## Examples

      iex> find_and_confirm_password(args)
      %User{}

      iex> find_and_confirm_password(args)
      ** (Ecto.NoResultsError)

  """
  def find_and_confirm_password(%{"email" => email, "password" => password}) do
    user = get_user_by_email(email)
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Credencias do login invalidas"}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
