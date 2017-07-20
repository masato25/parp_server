defmodule ParpServer.CarController do
  use ParpServer.Web, :controller

  alias ParpServer.Car

  def index(conn, _params) do
    cat = Repo.all(Car)
    render(conn, "index.json", cat: cat)
  end

  def create(conn, %{"car" => car_params}) do
    changeset = Car.changeset(%Car{}, car_params)

    case Repo.insert(changeset) do
      {:ok, car} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", car_path(conn, :show, car))
        |> render("show.json", car: car)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    car = Repo.get!(Car, id)
    render(conn, "show.json", car: car)
  end

  def update(conn, %{"id" => id, "car" => car_params}) do
    car = Repo.get!(Car, id)
    changeset = Car.changeset(car, car_params)

    case Repo.update(changeset) do
      {:ok, car} ->
        render(conn, "show.json", car: car)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ParpServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    car = Repo.get!(Car, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(car)

    send_resp(conn, :no_content, "")
  end

  def indexhtml(conn, _) do
    conn |>
    put_layout("car.html") |>
    render("car.html", %{})
  end
end
