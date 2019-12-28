defmodule ApiBankingWeb.TransacionadoController do
  use ApiBankingWeb, :controller
  use PhoenixSwagger

  alias ApiBanking.{BankTransfer, Saques}

  action_fallback ApiBankingWeb.FallbackController

  swagger_path :transacionado_by_day do
    get "/api/v1/transacionado/day/{day}/{account}"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    parameter("day", :header, :string, "Dia a ser buscado", required: true)
    parameter("account", :header, :string, "UUID da conta do usuário", required: true)
    summary "Recupera saques e transações por dia"
    description "Recupera saques e transações por dia"
    produces "application/json"
    tag "Transacionados"
    response 200, "OK", Schema.ref(:Transacionados)
    response 401, "Unauthorized"
  end

  def transacionado_by_day(conn, %{"day" => day, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_day(String.to_integer(day), id_account)
    saques = Saques.list_saques_by_day(String.to_integer(day), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end

  swagger_path :transacionado_by_month do
    get "/api/v1/transacionado/month/{month}/{account}"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    parameter("month", :header, :string, "Dia a ser buscado", required: true)
    parameter("account", :header, :string, "UUID da conta do usuário", required: true)
    summary "Recupera saques e transações por dia"
    description "Recupera saques e transações por dia"
    produces "application/json"
    tag "Transacionados"
    response 200, "OK", Schema.ref(:Transacionados)
    response 401, "Unauthorized"
  end

  def transacionado_by_month(conn, %{"month" => month, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_month(String.to_integer(month), id_account)
    saques = Saques.list_saques_by_month(String.to_integer(month), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end

  swagger_path :transacionado_by_year do
    get "/api/v1/transacionado/year/{year}/{account}"
    parameter("Authorization", :header, :string, "JWT access token", required: true)
    parameter("year", :header, :string, "Dia a ser buscado", required: true)
    parameter("account", :header, :string, "UUID da conta do usuário", required: true)
    summary "Recupera saques e transações por dia"
    description "Recupera saques e transações por dia"
    produces "application/json"
    tag "Transacionados"
    response 200, "OK", Schema.ref(:Transacionados)
    response 401, "Unauthorized"
  end

  def transacionado_by_year(conn, %{"year" => year, "account" => id_account}) do
    tranferencias = BankTransfer.get_transfer_by_year(String.to_integer(year), id_account)
    saques = Saques.list_saques_by_year(String.to_integer(year), id_account)
    render(conn, "index.json", tranferencias: tranferencias, saques: saques)
  end

end
