defmodule ApiBankingWeb.SaqueView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.SaqueView

  def render("index.json", %{saques: saques}) do
    %{data: render_many(saques, SaqueView, "saque.json")}
  end

  def render("show.json", %{saque: saque}) do
    %{data: render_one(saque, SaqueView, "saque.json")}
  end

  def render("saque.json", %{saque: saque}) do
    %{id: saque.id,
      value: saque.value}
  end
end
