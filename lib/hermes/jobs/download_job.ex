defmodule Hermes.Jobs.DownloadJob do
  use Oban.Worker, queue: :default, max_attempts: 5

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user" => user, "repos" => repos}}) do
    Hermes.user_repos(user, repos)
    :ok
  end
end
