defmodule ApiBanking.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :api_banking,
                              module: ApiBanking.Guardian,
                              error_handler: ApiBanking.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end
