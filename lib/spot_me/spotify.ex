defmodule SpotMe.Spotify do
  @moduledoc """
  Wrapper for Spotify
  """
  @api_key Application.get_env(:spot_me, :api_key)
  @api_secret Application.get_env(:spot_me, :api_secret)
  @redirect_url Application.get_env(:spot_me, :redirect_url)
  @test_playlist "4kd23D4R4XnGot7FxJXDSc"


  def client_credentials do
    params = %{
      grant_type: "client_credentials"
    }

    auth_string = Base.encode64("#{@api_key}:#{@api_secret}")

    headers = [
      {"Authorization", "Basic #{auth_string}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    url = "https://accounts.spotify.com/api/token"

    {:ok, response} = HTTPoison.post(url, "", headers, params: params)
    {:ok, creds} = Jason.decode(response.body)
    creds
  end

  def playlist(id \\ @test_playlist) do
    url = "https://api.spotify.com/v1/playlists/#{id}"
    {:ok, response} = HTTPoison.get(url, bearer_auth())
    playlist = Jason.decode!(response.body)
    Enum.map(playlist["tracks"]["items"], fn track ->
      %{name: track["track"]["name"], id: track["track"]["id"]}
    end)
  end

  def playlist_features(id \\ @test_playlist) do
    this_playlist = playlist(id)
    ids =
      this_playlist
      |> Enum.map(fn track -> track.id end)
      |> Enum.join(",")

    tracks = Enum.reduce(this_playlist, %{}, fn track, acc -> Map.put(acc, track.id, track.name) end)

    url = "https://api.spotify.com/v1/audio-features?ids=#{ids}"
    {:ok, response} = HTTPoison.get(url, bearer_auth())
    features = Jason.decode!(response.body)

    Enum.map(features["audio_features"], fn feature -> Map.merge(feature, %{name: tracks[feature["id"]]}) end)
  end

  def danceability(id \\ @test_playlist) do
    id
    |> playlist_features
    |> Enum.map(fn feature -> 
      %{
        name: feature.name,
        danceability: feature["danceability"]
      }
    end)
    |> Enum.sort(fn song1, song2 -> song1.danceability >= song2.danceability end)
  end

  def bearer_auth do
    %{"access_token" => token, "token_type" => "Bearer"} = client_credentials()

    [
      {"Authorization", "Bearer #{token}"}
    ]
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) 
    |> Base.url_encode64 
    |> binary_part(0, length)
  end  
end