



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class OkHttpClientAdapter {

   HttpClient _client;

    OkHttpClientAdapter(){
        this._client = new HttpClient();
    }


       send(HttpRequest httpRequest) async {

        RequestOptions request = buildOkRequestFromMsalRequest(httpRequest);
        BaseOptions options = BaseOptions();
        options.headers.addAll(request.headers);

       var data = await Dio(options).request(request.path);
        Map<String, List<String>> headers = data.headers.map;

       ResponseBody response = ResponseBody(data.data, data.statusCode, statusMessage: data.statusMessage, headers: headers, isRedirect: data.isRedirect, redirects: data.redirects);



        return buildMsalResponseFromOkResponse(response);
    }

         buildOkRequestFromMsalRequest(HttpRequest httpRequest){

        if(httpRequest.method == 'GET'){
            return buildGetRequest(httpRequest);
        } else if(httpRequest.method == 'POST'){
            return buildPostRequest(httpRequest);
        } else {
            throw new Exception("HttpRequest method should be either GET or POST");
        }
    }

    buildGetRequest(HttpRequest httpRequest){

        var request = RequestOptions(method: httpRequest.method, data: httpRequest.uri.data, path: httpRequest.uri.path);
        Map<String, dynamic> mapReq = new Map();
        httpRequest.headers.forEach((name, values) {
            print( "name -> $name");
            values.forEach((element) {
                print("Elemente - > $element");
            });

        });

       return request;



        // return new Request.Builder()
        //         .url(httpRequest.url())
        //         .headers(headers)
        //         .build();
    }

    buildPostRequest(HttpRequest httpRequest){
        String contentType = httpRequest.headers.contentType.value;
        print( "contentType -> $contentType");

        var request = RequestOptions(method: httpRequest.method, data: httpRequest.uri.data, path: httpRequest.uri.path);

        httpRequest.headers.forEach((name, values) {
            print( "name -> $name");
            values.forEach((element) {
                print("Elemente - > $element");
            });

        });

       return request;
       // MediaType type = MediaType.parse(contentType);

        //String requestBody = Request(type, httpRequest).; //RequestBody.create(type, httpRequest.body());

        // return new Request.Builder()
        //         .url(httpRequest.url())
        //         .post(requestBody)
        //         .headers(headers)
        //         .build();
    }

   buildMsalResponseFromOkResponse(ResponseBody okHttpResponse) async {

        HttpResponse httpResponse;

        String body = okHttpResponse.stream.toString();
        if(body != null){
            httpResponse.reasonPhrase = body;
        }

        okHttpResponse.headers.entries.forEach((element) {
            httpResponse.headers.add(element.key,element.value);
            print("MSAL ${element.key} -- ${element.value}");
        });

        return httpResponse;
    }
}
