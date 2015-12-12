defmodule Day8 do
  # @moduledoc """
  #   --- Day 8: Matchsticks ---
  #
  #   Space on the sleigh is limited this year, and so Santa will be bringing
  #   his list as a digital copy. He needs to know how much space it will take up when stored.
  #
  #   It is common in many programming languages to provide a way to escape special characters
  #   in strings. For example, C, JavaScript, Perl, Python, and even PHP handle special
  #   characters in very similar ways.
  #
  #   However, it is important to realize the difference between the number of characters in
  #   the code representation of the string literal and the number of characters in the in-memory
  #   string itself.
  #
  #   For example:
  #
  #   - "" is 2 characters of code (the two double quotes), but the string contains zero characters.
  #   - "abc" is 5 characters of code, but 3 characters in the string data.
  #   - "aaa\"aaa" is 10 characters of code, but the string itself contains six "a" characters and
  #     a single, escaped quote character, for a total of 7 characters in the string data.
  #   - "\x27" is 6 characters of code, but the string itself contains just one - an apostrophe ('),
  #     escaped using hexadecimal notation.
  #   - Santa's list is a file that contains many double-quoted string literals, one on each line.
  #     The only escape sequences used are \\ (which represents a single backslash), \" (which
  #     represents a lone double-quote character), and \x plus two hexadecimal characters (which
  #     represents a single character with that ASCII code).
  #
  #   Disregarding the whitespace in the file, what is the number of characters of code for string
  #   literals minus the number of characters in memory for the values of the strings in total for the entire file?
  #
  #   For example, given the four strings above, the total number of characters of string
  #   code (2 + 5 + 10 + 6 = 23) minus the total number of characters in memory for string
  #   values (0 + 3 + 7 + 1 = 11) is 23 - 11 = 12.
  #
  #   --- Part Two ---
  #
  #   Now, let's go the other way. In addition to finding the number of characters of code, you should
  #   now encode each code representation as a new string and find the number of characters of the new
  #   encoded representation, including the surrounding double quotes.
  #
  #   For example:
  #
  #   - "" encodes to "\"\"", an increase from 2 characters to 6.
  #   - "abc" encodes to "\"abc\"", an increase from 5 characters to 9.
  #   - "aaa\"aaa" encodes to "\"aaa\\\"aaa\"", an increase from 10 characters to 16.
  #   - "\x27" encodes to "\"\\x27\"", an increase from 6 characters to 11.
  #
  #   Your task is to find the total number of characters to represent the newly encoded
  #   strings minus the number of characters of code in each original string literal.
  #
  #   For example, for the strings above, the total encoded length (6 + 9 + 16 + 11 = 42)
  #   minus the characters in the original code representation (23, just like in the first
  #   part of this puzzle) is 42 - 23 = 19.
  #
  # """

  def size_difference(str), do: String.length(str) - size_in_bytes(str)

  def size_in_bytes(str), do: size_in_bytes(str, 0)

  def size_in_bytes("", acc), do: acc
  def size_in_bytes("\"" <> rest, acc), do: size_in_bytes(rest, acc)
  def size_in_bytes("\\x" <> <<_, _>> <> rest, acc), do: size_in_bytes(rest, acc + 1)
  def size_in_bytes("\\\\" <> rest, acc), do: size_in_bytes(rest, acc + 1)
  def size_in_bytes(<<_>> <> rest, acc), do: size_in_bytes(rest, acc + 1)

  def encode(str), do: encode(str, "")

  def encode("", acc), do: "\"#{acc}\""
  def encode("\"" <> rest, acc), do: encode(rest, acc <> "\\\"")
  def encode("\\" <> rest, acc), do: encode(rest, acc <> "\\\\")
  def encode(<<c>> <> rest, acc), do: encode(rest, acc <> <<c>>)

end


ExUnit.start

defmodule Day8Test do
  use ExUnit.Case, async: true

  test "size_in_bytes" do
    assert 0 == Day8.size_in_bytes("\"\"")
    assert 3 == Day8.size_in_bytes("\"abc\"")
    assert 7 == Day8.size_in_bytes("\"aaa\\\"aaa\"")
    assert 1 == Day8.size_in_bytes("\"\\x27\"")
    assert 7 == Day8.size_in_bytes("\"abc\\\\abc\"")
  end

  test "size_difference" do
    assert (2-0)  == Day8.size_difference("\"\"")
    assert (5-3)  == Day8.size_difference("\"abc\"")
    assert (10-7) == Day8.size_difference("\"aaa\\\"aaa\"")
    assert (6-1)  == Day8.size_difference("\"\\x27\"")
  end

  test "encode" do
    assert "\"\"" == Day8.encode("")
    assert "\"\\\"\\\"\"" == Day8.encode("\"\"")
    assert "\"\\\"abc\\\"\"" == Day8.encode("\"abc\"")
    assert "\"\\\"aaa\\\\\\\"aaa\\\"\"" == Day8.encode("\"aaa\\\"aaa\"")
    assert "\"\\\"\\\\x27\\\"\"" == Day8.encode("\"\\x27\"")
  end

  test "encoded size" do
    assert 6 == String.length(Day8.encode("\"\""))
    assert 9 == String.length(Day8.encode("\"abc\""))
    assert 16 == String.length(Day8.encode("\"aaa\\\"aaa\""))
    assert 11 == String.length(Day8.encode("\"\\x27\""))
  end

  test "input part 1" do
    IO.puts "part 1"
    File.stream!("day08.txt")
    |> Stream.map(&String.strip/1)
    |> Stream.map(&Day8.size_difference/1)
    |> Enum.sum
    |> IO.puts
  end

  test "input part 2" do
    IO.puts "part 2"
    File.stream!("day08.txt")
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn (str) -> {str, Day8.encode(str)} end)
    #|> Stream.map(fn (x) -> IO.inspect(x) end)
    |> Stream.map(fn ({str, encoded}) -> String.length(encoded) - String.length(str) end)
    |> Enum.sum
    |> IO.puts
  end
end
