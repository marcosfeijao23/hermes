defmodule Hermes.Data.Response do
  require Logger

  def build_response(user, repository, body_1, body_2) do
    labels = Enum.map(body_1, fn x -> build_labels(x) end)
    authors = Enum.map(body_1, fn x -> build_authors(x) end)
    titles = Enum.map(body_1, fn x -> Map.get(x, "title") end)
    issues_zip = Enum.zip([titles, authors, labels])
    issues = Enum.map(issues_zip, fn x -> tuple_to_map(x, :title, :author, :labels) end)

    Logger.info("Issues identificados!")
    Logger.info(issues_zip)

    names = Enum.map(body_2, fn x -> Map.get(x, "login") end)
    users = Enum.map(body_2, fn x -> Map.get(x, "id") end)
    qtd_commits = Enum.map(body_2, fn x -> Map.get(x, "contributions") end)
    contributors_zip = Enum.zip([names, users, qtd_commits])
    contributors = Enum.map(contributors_zip, fn x -> tuple_to_map(x, :name, :user, :qtd_commits) end)

    Logger.info("Contributors identificados!")
    Logger.info(contributors_zip)

    %{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    }
  end

  defp build_labels(data) do
    data
    |> Map.get("labels")
    |> Enum.map(fn x -> Map.get(x, "name") end)
  end

  defp build_authors(data) do
    data
    |> Map.get("user")
    |> Map.get("login")
  end

  defp tuple_to_map(tuple, titulo_1, titulo_2, titulo_3) do
    list = Tuple.to_list(tuple)

    %{}
    |> Map.put(titulo_1, Enum.at(list, 0))
    |> Map.put(titulo_2, Enum.at(list, 1))
    |> Map.put(titulo_3, Enum.at(list, 2))
  end
end
