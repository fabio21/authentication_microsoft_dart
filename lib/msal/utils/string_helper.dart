import 'dart:convert';
import 'dart:core';

class StringHelper {
  static const EMPTY_STRING = "";

  static bool isBlank(String str) {
    return str == null || str.trim().length == 0;
  }

  static String createBase64EncodedSha256Hash(String stringToHash) {
    return createSha256Hash(stringToHash);
  }

  static String createSha256Hash(String stringToHash,
      {bool isBase64Encode = true}) {
    String res;
    try {
      // Digest messageDigest = Digest.getInstance("SHA-256");

      // stringToHash.codeUnits(StandardCharsets.UTF_8
      var hash = utf8.encode(stringToHash);//messageDigest.digest(stringToHash.codeUnits);

      if (isBase64Encode) {
        res = Base64Encoder.urlSafe().convert(hash);
        //Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
      } else {
        res = Base64Codec.urlSafe().encode(hash);
        //new String(hash, StandardCharsets.UTF_8);
      }
    } catch (e) {
      res = null;
    }
    return res;
  }
}
