defmodule ApiBankingWeb.TransacionadoController do
  use ApiBankingWeb, :controller

  alias ApiBanking.{BankTransfer, Saques}

  action_fallback ApiBankingWeb.FallbackController

  def transacionado_by_day(conn, %{"day" => day, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_day(String.to_integer(day), id_account)
    saques = Saques.list_saques_by_day(String.to_integer(day), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end


  def transacionado_by_month(conn, %{"month" => month, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_month(String.to_integer(month), id_account)
    saques = Saques.list_saques_by_month(String.to_integer(month), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end


  def transacionado_by_year(conn, %{"year" => year, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_year(String.to_integer(year), id_account)
    saques = Saques.list_saques_by_year(String.to_integer(year), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end

end
