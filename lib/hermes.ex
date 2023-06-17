defmodule Hermes do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, [{"User-Agent: marcosfeijao23", "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"}]
  plug Tesla.Middleware.JSON

  @destino "https://webhook.site/ba722517-1e4b-4b88-984a-c37b768c6a64"

  def user_repos(user, repository) do
    {:ok, resposta_1} = get("/repos/" <> user <> "/" <> repository <> "/issues")

    {:ok, resposta_2} = get("/repos/" <> user <> "/" <> repository <> "/contributors")

    cond do
      resposta_1.status == 200 -> montar_resposta(user, repository, resposta_1.body, resposta_2.body)
      true -> "Usuário ou Repositório inválidos. Tente novamente!"
    end
  end

  defp montar_resposta(user, repository, body_1, body_2) do
    labels = Enum.map(body_1, fn x -> get_labels(x) end)
    authors = Enum.map(body_1, fn x -> get_authors(x) end)
    titles = Enum.map(body_1, fn x -> Map.get(x, "title") end)
    issues_zip = Enum.zip([titles, authors, labels])

    names = Enum.map(body_2, fn x -> Map.get(x, "login") end)
    users = Enum.map(body_2, fn x -> Map.get(x, "id") end)
    qtd_commits = Enum.map(body_2, fn x -> Map.get(x, "contributions") end)
    contributors_zip = Enum.zip([names, users, qtd_commits])

    issues = Enum.map(issues_zip, fn x -> organizar(x, :title, :author, :labels) end)
    contributors = Enum.map(contributors_zip, fn x -> organizar(x, :name, :user, :qtd_commits) end)

    mensagem =
    %{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    }

    @destino
    |> post(mensagem)
  end

  defp get_labels(data) do
    data
    |> Map.get("labels")
    |> Enum.map(fn x -> Map.get(x, "name") end)
  end

  defp get_authors(data) do
    data
    |> Map.get("user")
    |> Map.get("login")
  end

  defp organizar(tuple, titulo_1, titulo_2, titulo_3) do
    list = Tuple.to_list(tuple)

    %{}
    |> Map.put(titulo_1, Enum.at(list, 0))
    |> Map.put(titulo_2, Enum.at(list, 1))
    |> Map.put(titulo_3, Enum.at(list, 2))
  end
end
