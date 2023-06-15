defmodule HermesWeb.TestController do
  use HermesWeb, :controller

  def test(conn, params) do
    params
    |> Hermes.Jobs.DownloadJob.new()
    |> Oban.insert()

    ##### Delay de um dia: (schedule_in: 86400) #####
    data = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(-10800, :second)

    json(conn, %{mensagem: "Pedido de envio feito!", data: data})
  end
end
