
import 'dart:io';

class ApacheHttpClientAdapter {

    HttpClient _httpClient;

    ApacheHttpClientAdapter(){
        this._httpClient = HttpClient();
    }


   send(HttpRequest httpRequest) async {

        HttpRequest request = buildApacheRequestFromMsalRequest(httpRequest);

        var response = await _httpClient.open(request.method, request.headers.host, request.headers.port, request.uri.path);
        HttpResponse res = (await response.close()) as HttpResponse;
        return buildMsalResponseFromApacheResponse(res);
    }


    HttpRequest buildApacheRequestFromMsalRequest(HttpRequest httpRequest){

        if(httpRequest.method == "GET"){
            return builGetRequest(httpRequest);
        } else if(httpRequest.method == 'POST'){
            return buildPostRequest(httpRequest);
        } else {
            throw Exception("HttpRequest method should be either GET or POST");
        }
    }

     builGetRequest(HttpRequest httpRequest) async {
        //HttpGet httpGet = new HttpGet(httpRequest.url().toString());
          var httpGet = await _httpClient.getUrl(httpRequest.uri);
          httpRequest.headers.forEach((name, values) {
              httpGet.headers.add(name, values);
          });

        return httpGet;
    }

    buildPostRequest(HttpRequest httpRequest) async {
        //HttpPost httpPost = new HttpPost(httpRequest.url().toString());

        var httpPost = await _httpClient.postUrl(httpRequest.uri);
        httpRequest.headers.forEach((name, values) {
            httpPost.headers.add(name, values);
        });

        ContentType contentType = httpRequest.headers.contentType;


        // for(Map.Entry<String, String> entry: httpRequest.headers().entrySet()){
        //     httpPost.setHeader(entry.getKey(), entry.getValue());
        // }

        // String contentTypeHeaderValue = httpRequest.headerValue("Content-Type");
        // ContentType contentType = ContentType.getByMimeType(contentTypeHeaderValue);

        // StringEntity stringEntity = new StringEntity(httpRequest.body, contentType);
        //
        // httpPost.setEntity(stringEntity);
        return httpPost;
    }

    HttpResponse buildMsalResponseFromApacheResponse(HttpResponse apacheResponse) {

        HttpResponse httpResponse;
        httpResponse.statusCode = apacheResponse.statusCode;

        Map<String, List<String>> headers = new Map();
        apacheResponse.headers.forEach((name, values) {
            httpResponse.headers.add(name, values);
        });


        String responseBody = apacheResponse.reasonPhrase;
        httpResponse.reasonPhrase  = responseBody;
        return httpResponse;
    }
}
