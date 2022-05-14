defmodule ExmpesaWeb.PageController do
  use ExmpesaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
