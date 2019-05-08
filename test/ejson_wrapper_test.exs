defmodule EJSONWrapperTest do
  use ExUnit.Case

  describe "decrypt/1" do
    test "returns decrypted map" do
      assert {:ok, %{"secret" => "1234password"}} == EJSONWrapper.decrypt("test/ejson/test.ejson")
    end    
  end

  describe "decrypt/2" do
    test "returns decrypted map if ejson_keydir argument is provided" do
      assert {:ok, %{"secret" => "1234password"}} == EJSONWrapper.decrypt("test/ejson/test.ejson", ejson_keydir: "./test/ejson/keys")
    end

    test "returns decrypted map if private_key argument is provided" do
      assert {:ok, %{"secret" => "1234password"}} == EJSONWrapper.decrypt("test/ejson/test.ejson", private_key: "c6f22ca1baeca17af9c947052e1498b7e4944eea9b145f01bcabccf5c21a561c")
    end    
  end
end
