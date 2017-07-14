defmodule ParpServer.Helper.AvatarOps do
  alias ParpServer.Avatar
  alias ParpServer.AtHistory 
  alias ParpServer.Helper.TimeUtils
  alias ParpServer.Repo
  import Ecto.Query
  import Logger

  def findAvatar(avatar_params) do
    Logger.info("ggggg2")
    avatar = Repo.all(
      from ava in Avatar,
      where: ava.address == ^Map.get(avatar_params, "address")
    )
    Logger.info("ggggg3")
    cond do
      avatar != [] ->
        Map.get(hd(avatar), :id)
      true ->
        -1
    end
  end

  def create(%{"avatar" => avatar_params}) do
    Logger.info("ggggg")
    avatar_params = Map.put(avatar_params, "latest_report", TimeUtils.naiveTimeNow)
    # check avatar is existing?
    id = findAvatar(avatar_params)
    if id != -1 do
      params = %{"id" => id, "avatar" => avatar_params}
      update(params)
    else
      changeset = Avatar.changeset(%Avatar{}, avatar_params)
      case Repo.insert(changeset) do
        {:ok, avatar} ->
          Avatar.createAtHistory(avatar)
          Logger.info("avatar created with name #{Map.get(avatar_params, "name")}")
        {:error, changeset} ->
          Logger.error("avatar got error #{IO.inspect changeset} with name #{Map.get(avatar_params, "name")}")
      end
    end
  end

  def update(%{"id" => id, "avatar" => avatar_params}) do
    avatar = Repo.get!(Avatar, id)
    avatar_params = Map.put(avatar_params, "updated_at", DateTime.to_unix(Timex.now))
    changeset = Avatar.changeset(avatar, avatar_params)
    at_history = Avatar.findLastAtHistory(avatar)
    if is_nil(at_history) do
      Avatar.createAtHistory(avatar)
    end
    case Repo.update(changeset) do
      {:ok, avatar} ->
        Logger.info("avatar created with id #{id}")
      {:error, changeset} ->
        Logger.error("avatar got error #{IO.inspect changeset} with id #{id}")
    end
  end

  def level_parking(%{"address" => address}) do
    avatar = Repo.all(from ava in Avatar,
                      where: ava.address == ^address)
    if avatar == [] do
      Logger.error("error: no found address: #{address}")
    else
      at_history = Avatar.findLastAtHistory(hd(avatar))
      if is_nil(at_history) do
        Logger.info("error: no any parking info of #{avatar}")
      else
        avatar = AtHistory.changeset(at_history, %{status: "leave", end_at: TimeUtils.naiveTimeNow})
        case Repo.update(avatar) do
          {:ok, changeset} ->
          Logger.info("avatar delete with address: #{address}")
          {:error, changeset} ->
            Logger.error("[avatar_leave_pakring] update at_history got error: #{IO.inspect Map.get(changeset, :errors)}")
        end
      end
    end
  end
end
