defmodule ApiBankingWeb.AccountView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.AccountView
  alias ApiBankingWeb.ChangesetView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      agency: account.agency,
      account: account.account,
      balance: account.balance,
      user_id: account.user_id
    }
  end

  def render("error.json", %{changeset: changeset}) do
    ChangesetView.render("error.json", changeset: changeset)
  end
end
