defmodule Hermes.Data.Actions do
  def send(params) do
    ##### Delay de um dia: (schedule_in: 86400) #####
    params
    |> Hermes.Jobs.DownloadJob.new()
    |> Oban.insert()
  end
end
