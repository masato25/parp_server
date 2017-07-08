defmodule ParpServer.CarView do
  use ParpServer.Web, :view

  def render("index.json", %{cat: cat}) do
    %{data: render_many(cat, ParpServer.CarView, "car.json")}
  end

  def render("show.json", %{car: car}) do
    %{data: render_one(car, ParpServer.CarView, "car.json")}
  end

  def render("car.json", %{car: car}) do
    %{id: car.id,
      plate: car.plate,
      detected_data: car.detected_data,
      img: car.picture
    }
  end
end
