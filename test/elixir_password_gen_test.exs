defmodule ElixirPasswordGenTest do
  use ExUnit.Case
  doctest ElixirPasswordGen
  
  setup do
    options = %{
      "length" => 10,
      "lowercase" => true,
      "uppercase" => false,
      "numbers" => false,
      "symbols" => false
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, & <<&1>>),
      symbols: String.split("!@#$%^&*()_+-=[]{};':,./<>?", "", trim: true)
    }
    {:ok, result } = ElixirPasswordGen.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "return a string", %{:result: result} do
    assert is_bitstring(result)
  end

  test "returns error when no lenght is given" do 
    options = %{"invalid" => "false"}
    assert {:error, _error} = ElixirPasswordGen.generate(options)
  end

  test "returns error when length is not an integer" do
    options = %{"length" => "ab"}
    assert {:error, _error} = ElixirPasswordGen.generate(options)
  end

  test "length of returned string is the option provided" do
    options = %{"length" => "5"}
    {:ok, result} = ElixirPasswordGen.generate(options)
    assert 5 = String.length(result)
  end

  test "returns a lowercase string just with the length", %{options_type: options} do
    length = %{"length" => "5"}
    {:ok, result} = ElixirPasswordGen.generate(length)

    assert String.contains?(result, options[:lowercase])
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  test "returns error when options values are not booleans" do
    options = %{
      "length" => "10",
      "uppercase" => "0",
      "numbers" => "invalid",
      "symbols" => "false"
    }
    assert {:error, _error} = ElixirPasswordGen.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{"length" => "10", "invalid" => "true"}
    assert {:error, _error} = ElixirPasswordGen.generate(options)
  end

  test "returns error when 1 option not allowed" do
    options = %{"length" => "5", "invalid" => "true", "numbers" => "true"}
    assert {:error, _error} = ElixirPasswordGen.generate(options)
  end

end


