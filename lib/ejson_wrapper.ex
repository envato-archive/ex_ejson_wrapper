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

      iex> EJSONWrapper.decrypt("file_path/file.ejson", private_key: "REDACTED")
      {:ok, %{"key" => "value"}}

  """
  def decrypt(file_path, ejson_keydir: ejson_keydir) do
    with {:ok, private_key_path} <- read_ejson_file(file_path, ejson_keydir),
         {:ok, private_key} <- read_private_key(private_key_path)
    do
      decrypt(file_path, private_key: private_key)
    else
      err -> err
    end
  end

  def decrypt(file_path, private_key: private_key) do
    case Porcelain.shell("echo \"#{private_key}\" | ejson decrypt #{file_path} --key-from-stdin", err: :out) do
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

  defp read_private_key(file_path) do
    case File.read(file_path) do
      {:ok, private_key} ->
        {:ok, private_key}
      {:error, :enoent} ->
        {:error, "Decryption failed: stat #{file_path}: no such file or directory"}
    end
  end

  defp read_ejson_file(file_path, ejson_keydir) do
    case File.read(file_path) do
      {:ok, ejson_string} ->
        ejson_map = json_decode(ejson_string)
        private_key_path = ejson_keydir <> "/" <> ejson_map["_public_key"]

        {:ok, private_key_path}
      {:error, :enoent} ->
        {:error, "Decryption failed: stat #{file_path}: no such file or directory"}
    end
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
