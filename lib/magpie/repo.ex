defmodule Magpie.Repo do
  use Ecto.Repo,
    otp_app: :magpie,
    adapter: Ecto.Adapters.Postgres

  @spec normalize_one_result(any()) :: {:ok, any()} | {:error, :not_found}
  def normalize_one_result(nil), do: {:error, :not_found}
  def normalize_one_result(result), do: {:ok, result}

  @spec normalize_one_result(any(), String.t()) ::
          {:ok, any()} | {:error, String.t()}
  def normalize_one_result(nil, not_found_message) when is_binary(not_found_message),
    do: {:error, not_found_message}

  def normalize_one_result(result, not_found_message) when is_binary(not_found_message),
    do: {:ok, result}
end
