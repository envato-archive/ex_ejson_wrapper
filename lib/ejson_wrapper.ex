defmodule EJSONWrapper do
  alias Porcelain.Result

  @moduledoc """
  Decrypt EJSON file
  """

  @doc """
  Decrypt an EJSON file

  ## Examples

      iex> EJSONWrapper.decrypt("file_path/file.ejson")
      {:ok, %{"key" => "value"}}

      iex> EJSONWrapper.decrypt("file_path/file.ejson", ejson_keydir: "/path_to/ejson_keys")
      {:ok, %{"key" => "value"}}

  """
  def decrypt(file_path, ejson_keydir: ejson_keydir) do
    case Porcelain.exec("ejson", ["decrypt", file_path], err: :out, env: [{"EJSON_KEYDIR", ejson_keydir}]) do
      %Result{err: :out, out: output, status: 0} ->
        sanitized_output = output
                          |> json_decode
                          |> sanitize
        {:ok, sanitized_output}

      %Result{err: :out, out: output, status: 1} ->
        {:error, "#{output}"}
    end
  end

  def decrypt(file_path) do
    decrypt(file_path, ejson_keydir: Application.get_env(:ex_ejson_wrapper, :ejson_keydir))
  end

  defp json_decode(json_string) do
    json_string
    |> json_decoder().decode!
  end

  defp json_decoder do
    Application.get_env(:ex_ejson_wrapper, :json_codec)
  end

  defp sanitize(map) do
    map
    |> Map.delete("_public_key")
  end
end
