defmodule Hermes do
  use Tesla
  require Logger
  alias Hermes.Data.Response

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, [{"User-Agent: ", ""}]
  plug Tesla.Middleware.JSON

  @destino "https://webhook.site/ba722517-1e4b-4b88-984a-c37b768c6a64"

  def user_repos(user, repository) do
    {:ok, resposta_1} = get("/repos/" <> user <> "/" <> repository <> "/issues")

    {:ok, resposta_2} = get("/repos/" <> user <> "/" <> repository <> "/contributors")

    Logger.info("Solicitação de dados feita! Status: #{resposta_1.status}")

    cond do
      resposta_1.status == 200 -> Response.build_response(user, repository, resposta_1.body, resposta_2.body) |> send_response()
      resposta_1.status == 404 -> "Usuário ou Repositório inválidos. Tente novamente!"
      true -> "Erro desconhecido. Tente novamente!"
    end
  end

  defp send_response(message) do
    Logger.info("Mensagem pronta para envio!")

    @destino
    |> post(message)
  end
end
