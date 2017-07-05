defmodule ParpServer.Helper.TimeUtils do

  def convertNaiveToUnix(naiveTime) do
    DateTime.from_naive!(naiveTime, "Etc/UTC") |>
    DateTime.to_unix
  end

  def converUnixTs(unixt) do
    datetime = Timex.from_unix(unixt, :second)
    timezone = Timex.Timezone.get("Asia/Taipei", Timex.now())
    Timex.Timezone.convert(datetime, timezone)
  end

  def converTs(unixtime) do
    timezone = Timex.Timezone.get("Asia/Taipei", Timex.now())
    unixtime 
    |> Timex.from_unix(:second)
    |> Timex.Timezone.convert(timezone)
    |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime)
  end

  def naiveTimeNow() do
    NaiveDateTime.from_erl!(Timex.to_erl(Timex.now))
  end

  def naiveTimeConver(timeTs) do
    cond do
      !is_nil(timeTs) ->
        convertNaiveToUnix(timeTs) |>
        converTs
      true ->
        timeTs
    end
  end

end
