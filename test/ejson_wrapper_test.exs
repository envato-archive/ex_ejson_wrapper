defmodule EJSONWrapperTest do
  use ExUnit.Case

  describe "decrypt/1" do
    test "returns decrypted map" do
      assert {:ok, %{"secret" => "1234password"}} == EJSONWrapper.decrypt("test/ejson/test.ejson")
    end    
  end

  describe "decrypt/2" do
    test "returns decrypted map" do
      assert {:ok, %{"secret" => "1234password"}} == EJSONWrapper.decrypt("test/ejson/test.ejson", ejson_keydir: "./test/ejson/keys")
    end    
  end
end
