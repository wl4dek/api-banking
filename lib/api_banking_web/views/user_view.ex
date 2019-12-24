defmodule ApiBankingWeb.UserView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end

  def render("login.json", %{user: user, token: token, exp: exp}) do
    %{
      user: render_one(user, UserView, "user.json"),
      token: token,
      exp: exp
    }
  end

  def render("message.json", %{message: message}) do
    %{
      message: message
    }
  end
end
