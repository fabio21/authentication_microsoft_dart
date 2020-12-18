
class HttpClientHelper {

static String sendRequestToLab(String labUrl, String accessToken, {String id, Map<String, String> queryMap}) {
    Uri url;
    if(id != null){
      url =  Uri.encodeFull('$labUrl/$id') as Uri;
    }else if (queryMap != null){
      url = buildUrl(labUrl, queryMap);
    }
   // HttpsURLConnection conn = (HttpsURLConnection) labUrl.openConnection();
   //  conn.setRequestProperty("Authorization", "Bearer " + accessToken);
   //  conn.setReadTimeout(20000);
   //  conn.setConnectTimeout(20000);

  //   StringBuffer content;
  //   try(BufferedReader inx = new BufferedReader(new InputStreamReader(conn.getInputStream()))){
  //     String inputLine;
  //     content = new StringBuffer();
  //     while((inputLine = inx.readLine()) != null){
  //       content.write(inputLine);
  //     }
  //   }
  // conn.disconnect();
 // return content.toString();

  return null;
}

static Uri buildUrl(String url, Map<String, String> queryMap){
String queryParameters = queryMap.entries.map( (p) => encodeUTF8(p.key) + "=" + encodeUTF8(p.value)).reduce((p1, p2) => p1 + "&" + p2);

// String urlString = url + "?" + queryParameters;
// return new URL(urlString);
return Uri.https(url, queryParameters);
}

static String encodeUTF8(String s){
  try {
    return Uri.encodeFull(s);
  } catch(e) {
  throw new Exception("Error: cannot encode query parameter " + s );
  }
}
}
