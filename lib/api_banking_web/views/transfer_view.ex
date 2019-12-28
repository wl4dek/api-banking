defmodule ApiBankingWeb.TransferView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.TransferView
  alias ApiBankingWeb.ChangesetView

  def render("index.json", %{transfers: transfers}) do
    %{data: render_many(transfers, TransferView, "transfer.json")}
  end

  def render("show.json", %{transfer: transfer}) do
    %{data: render_one(transfer, TransferView, "transfer.json")}
  end

  def render("transfer.json", %{transfer: transfer}) do
    %{
      id: transfer.id,
      origin: transfer.origin,
      destination: transfer.destination,
      value: transfer.value
    }
  end

  def render("error.json", %{changeset: changeset}) do
    ChangesetView.render("error.json", changeset: changeset)
  end
end
