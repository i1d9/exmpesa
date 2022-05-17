defmodule ExmpesaWeb.Mpesa do

  
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

  def stk_init_url do
    "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
  end

  def stk_password do
    timestamp = gen_timesetamps()
    online_pass_key = Application.fetch_env!(:mpesa_api, :online_pass_key)
    online_short_code = Application.fetch_env!(:mpesa_api, :online_short_code)
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

  def send_stk(
        phone,
        amount,
        account_reference \\ "Test Payment",
        transaction_description \\ "Testing"
      ) do
    headers = [{"Content-type", "application/json"}, {"Authorization", "Bearer #{auth_token()}"}]
    timestamp = gen_timesetamps()
    password = stk_password()

    online_short_code = Application.fetch_env!(:mpesa_api, :online_short_code)
    call_back_url = Application.fetch_env!(:mpesa_api, :call_back_url)

    body =
      Poison.encode!(%{
        "BusinessShortCode" => online_short_code,
        "Password" => password,
        "Timestamp" => timestamp,
        "TransactionType" => "CustomerPayBillOnline",
        "Amount" => amount,
        "PartyA"=> phone,
        "PartyB" => online_short_code,
        "PhoneNumber"=> phone,
        "CallBackURL"=> call_back_url,
        "AccountReference"=> account_reference,
        "TransactionDesc"=> transaction_description
      })

    {:ok, response } = HTTPoison.post(stk_init_url(), body, headers)
    response
  end


end
