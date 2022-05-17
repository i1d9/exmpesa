defmodule ExmpesaWeb.Mpesa do
  def lipaNaMpesaOnlinePassKey do
    "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
  end

  def lipaNaMpesaOnlineShortCode do
    "174379"
  end

  def headers() do
    consumer_key = Application.fetch_env!(:mpesa_api, :consumer_key)
    consumer_secret = Application.fetch_env!(:mpesa_api, :consumer_secret)
    concat_key_secret = Base.encode64("#{consumer_key}:#{consumer_secret}")
    [Authorization: "Basic #{concat_key_secret}"]
  end

  def credentials_url do
    "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
  end

  def auth_token() do
    with {:ok, %{body: body} = %HTTPoison.Response{}} =
           HTTPoison.get(credentials_url(), headers()),
         {:ok, %{"access_token" => token}} = Poison.decode(body) do
      token
    end
  end

  def stk_password do
    timestamp = gen_timesetamps()
    online_pass_key = Application.fetch_env!(:mpesa_api, :consumer_key)
    online_short_code = Application.fetch_env!(:mpesa_api, :consumer_secret)
    Base.encode64("#{online_short_code}#{online_pass_key}#{timestamp}")
  end

  def gen_timesetamps() do
    today =
      Timex.now("Africa/Nairobi")
      |> Timex.to_datetime()

    timestamp =
      [today.year, today.month, today.day, today.hour, today.minute, today.second]
      |> Enum.map(&to_string/1)
      |> Enum.map(&String.pad_leading(&1, 2, "0"))
      |> Enum.join()

    timestamp
  end


  def send_stk(phone, amount, account_reference ) do
    headers = [Authorization: "Basic #{auth_token()}"]
  end
end
