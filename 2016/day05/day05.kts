
val CHARS = arrayOf('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f')

fun Byte.toHexString() : String {
    val i = this.toInt()
    val char2 = CHARS[i and 0x0f]
    val char1 = CHARS[i shr 4 and 0x0f]
    return "$char1$char2"
}

fun ByteArray.toHexString() : String {
    val builder = StringBuilder()
    for (b in this) {
        builder.append(b.toHexString())
    }
    return builder.toString()
}

fun md5(input: String) : String {
  val digest = java.security.MessageDigest.getInstance("MD5")
  return digest.digest(input.toByteArray()).toHexString()
}

fun guessPassword(input: String) {
  generateSequence(0) { it + 1 }
    .map { md5(input + it) }
    .filter { it.startsWith("00000") }
    .map { s:String -> s.substring(5, 6) }
    .take(8)
    .forEach { s:String -> println(s) }
}

guessPassword("reyedfim")
