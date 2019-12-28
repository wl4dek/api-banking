defmodule ApiBankingWeb.TransacionadoView do
  use ApiBankingWeb, :view
  alias ApiBankingWeb.SaqueView
  alias ApiBankingWeb.TransferView

  def render("index.json", %{tranferencias: tranferencias, saques: saques}) do
    %{
      tranferencias: render_many(tranferencias, TransferView, "transfer.json"),
      saques: render_many(saques, SaqueView, "saque.json"),
    }
  end

end
