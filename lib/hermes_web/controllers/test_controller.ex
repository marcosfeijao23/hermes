defmodule HermesWeb.TestController do
  use HermesWeb, :controller

  def test(conn, params) do
    Hermes.Data.Actions.send(params)

    date = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.add(-10800, :second)

    json(conn, %{message: "Pedido de envio feito!", date: date})
  end
end
