defmodule ParpServer.AtHistoryView do
  use ParpServer.Web, :view
  alias ParpServer.Helper.TimeUtils, as: TS

  def render("index.json", %{at_history: at_history}) do
    %{data: render_many(at_history, ParpServer.AtHistoryView, "at_history.json")}
  end

  def render("show.json", %{at_history: at_history}) do
    %{data: render_one(at_history, ParpServer.AtHistoryView, "at_history.json")}
  end

  def render("at_history.json", %{at_history: at_history}) do
    %{id: at_history.id,
      start_at: TS.naiveTimeConver(at_history.start_at),
      end_at: TS.naiveTimeConver(at_history.end_at),
      status: at_history.status,
      avatar_id: at_history.avatar_id}
  end
end
