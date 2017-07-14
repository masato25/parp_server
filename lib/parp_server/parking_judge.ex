defmodule  ParpServer.ParkingJudge do

  require Logger
  alias ParpServer.Repo
  import Ecto.Query
  alias ParpServer.AtHistory
  alias ParpServer.Avatar
  alias ParpServer.Helper.TimeUtils

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(msg) do
    schedule_work()

    {:ok, msg}
  end

  def cleanTimeOutParking() do
    ats = Repo.all(
      from atHistory in AtHistory,
      where: atHistory.status == ^"parking"
    )
    Enum.each(ats, fn at ->
      avatar = Repo.get!(Avatar, Map.get(at, :avatar_id))
      ut = Map.get(avatar, :latest_report) |> TimeUtils.convertNaiveToUnix
      # 如果最後上報時間相差240秒才更新
      if (Timex.to_unix(Timex.now) - ut ) > 240 do
          changeset = AtHistory.changeset(at, %{end_at: TimeUtils.naiveTimeNow, status: "leave"})
          Repo.update(changeset)
      end
    end)
  end

  defp schedule_work() do
    Process.send_after(self(), :cleanTimeOutParking, (60 * 1000))
  end

  def handle_info(:cleanTimeOutParking, state) do
    cleanTimeOutParking()
    schedule_work()
    {:noreply, state}
  end

end
