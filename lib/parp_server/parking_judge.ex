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
    # set timeout is 20 sec
    timeOutBase = Timex.to_unix(Timex.now) - (20)
      |>  TimeUtils.converUnixTs
      |>  Timex.to_erl
      |>  NaiveDateTime.from_erl!
    avatars = Repo.all(
      from avatar in Avatar,
      where: avatar.latest_report < ^timeOutBase
    )
    Enum.each(avatars, fn avatar ->
      atHistory = Avatar.findLastAtHistory(avatar)
      if !is_nil(atHistory) do
        changeset = AtHistory.changeset(atHistory, %{end_at: TimeUtils.naiveTimeNow, status: "leave"})
        Repo.update(changeset)
      end
    end)
  end

  defp schedule_work() do
    Process.send_after(self(), :cleanTimeOutParking, (10 * 1000))
  end

  def handle_info(:cleanTimeOutParking, state) do
    # Logger.info("will talke 2")
    cleanTimeOutParking()
    schedule_work()
    {:noreply, state}
  end

end
