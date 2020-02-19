defmodule SpotMe.Spotify do
  @moduledoc """
  Wrapper for Spotify
  """
  @api_key Application.get_env(:spot_me, :api_key)
  @api_secret Application.get_env(:spot_me, :api_secret)
  @redirect_url Application.get_env(:spot_me, :redirect_url)

  # def authorize_url do
  #   state = random_string(32)
  #   params = %{
  #     client_id: @api_key,
  #     response_type: "code",
  #     redirect_uri: @redirect_url,
  #     state: state,
  #     scopes: "user-read-private user-read-email"
  #   }
  #   query_string = URI.encode_query(params)
  #   "https://accounts.spotify.com/authorize?" <> query_string
  # end

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

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) 
    |> Base.url_encode64 
    |> binary_part(0, length)
  end  
end