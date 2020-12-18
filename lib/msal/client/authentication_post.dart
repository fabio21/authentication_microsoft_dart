
import 'package:microsoft_authentication/msal/utils/collections.dart';

class ClientAuthenticationPost extends ClientAuthentication {

    ClientAuthenticationPost(ClientAuthenticationMethod method, ClientID clientID) {
        //super(method, clientID);
    }

    Map<String, List<String>> toParameters() {

        Map<String, List<String>> params = new Map();

        params["client_id"] = Collections.singleton(getClientID().getValue());

        return params;
    }

     void applyTo(HTTPRequest httpRequest)  {

        if (httpRequest.getMethod() != HTTPRequest.Method.POST)
            throw new Exception("The HTTP request method must be POST");

        String ct = (httpRequest.getEntityContentType().toString();

        if (ct == null)
            throw new Exception("Missing HTTP Content-Type header");

        if (!ct.equals(HTTPContentType.ApplicationURLEncoded.contentType))
            throw new Exception(
                    "The HTTP Content-Type header must be " + HTTPContentType.ApplicationURLEncoded.contentType);

        Map<String, List<String>> params = httpRequest.getQueryParameters();

        params.putAll(toParameters());

        String queryString = URLUtils.serializeParameters(params);

        httpRequest.setQuery(queryString);
    }
}
