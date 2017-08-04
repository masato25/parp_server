defmodule ParpServer.Session do
  use ParpServer.Web, :model
  alias ParpServer.User
  alias ParpServer.Repo
  schema "session" do
    field :session_key, :string
    belongs_to :user, User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :session_key])
    |> validate_required([:user_id])
    |> makesessionkey
  end

  defp makesessionkey(data) do
    changes = Map.get(data, :changes, %{})
    changes = Map.put(changes, :session_key, genhash())
    Map.put(data, :changes, changes)
  end

  defp genhash() do
    slength = 16
    :crypto.strong_rand_bytes(slength) |> Base.url_encode64 |> binary_part(0, slength)
  end

  def checkSession(session) do
    username = Map.get(session, :username, "")
    session_key = Map.get(session, :token, "")
    cks = Repo.all(from user in User,
      where: user.username == ^username,
      limit: 1,
      preload: [:sessions]
    )
    if cks == [] do
      false
    else
      cks = cks |> hd
      st = cks.sessions |> Enum.filter(fn ss ->
        Map.get(ss, :session_key, "") == session_key
      end)
      if st == [] do
        false
      else
        Map.delete(cks, :sessions)
      end
    end
  end
end
