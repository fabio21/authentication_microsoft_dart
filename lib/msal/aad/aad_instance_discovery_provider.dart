
import 'dart:io';

import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/authority/authority_type.dart';
import 'package:microsoft_authentication/msal/utils/collections.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'aad_instance_discovery_response.dart';
import 'instance_discovery_metadata_entry.dart';

class AadInstanceDiscoveryProvider {

    static const _DEFAULT_TRUSTED_HOST = "login.microsoftonline.com";
    static const _AUTHORIZE_ENDPOINT_TEMPLATE = "https://{host}/{tenant}/oauth2/v2.0/authorize";
    static const _INSTANCE_DISCOVERY_ENDPOINT_TEMPLATE = "https://{host}/common/discovery/instance";
    static const _INSTANCE_DISCOVERY_REQUEST_PARAMETERS_TEMPLATE = "?api-version=1.1&authorization_endpoint={authorizeEndpoint}";

     static Set<String> TRUSTED_HOSTS_SET = [
       "login.windows.net",
       "login.chinacloudapi.cn",
       "login-us.microsoftonline.com",
       "login.microsoftonline.de",
       "login.microsoftonline.com",
       "login.microsoftonline.us",
     ].toSet();

    static Map<String, InstanceDiscoveryMetadataEntry> cache = new Map();


    static getMetadataEntry(Uri authorityUrl, bool validateAuthority, MsalRequest msalRequest, ServiceBundle serviceBundle) {
        var result = cache[authorityUrl.authority];
        if (result == null) {
            doInstanceDiscoveryAndCache(authorityUrl, validateAuthority, msalRequest, serviceBundle);
        }

        return cache[authorityUrl.authority];
    }

    static Set<String> getAliases(String host){
        if(cache.containsKey(host)){
            return cache[host].aliases.toSet();
        }
        else{
          return Collections.singleton(host).toSet();
        }
    }

    static AadInstanceDiscoveryResponse parseInstanceDiscoveryMetadata(String instanceDiscoveryJson) {

        AadInstanceDiscoveryResponse aadInstanceDiscoveryResponse;
        try {
            aadInstanceDiscoveryResponse = JsonHelper.convertJsonToObject(
                    instanceDiscoveryJson,
                    AadInstanceDiscoveryResponse);

        } catch(ex){
            throw new MsalClientException("Error parsing instance discovery response. Data must be " +
                    "in valid JSON format. For more information, see https://aka.ms/msal4j-instance-discovery",
                    AuthenticationErrorCode.INVALID_INSTANCE_DISCOVERY_METADATA);
        }

        return aadInstanceDiscoveryResponse;
    }

    static void cacheInstanceDiscoveryMetadata(String host, AadInstanceDiscoveryResponse aadInstanceDiscoveryResponse) {

        if (aadInstanceDiscoveryResponse != null && aadInstanceDiscoveryResponse.metadata != null) {
            for (InstanceDiscoveryMetadataEntry entry in aadInstanceDiscoveryResponse.metadata) {
                for (String alias in entry.aliases) {
                    cache[alias] = entry;
                }
            }
        }
       var isn = InstanceDiscoveryMetadataEntry(preferredCache: host,  preferredNetwork: host, aliases:[host]);
        cache.putIfAbsent(host, () => isn);
    }

    static String getAuthorizeEndpoint(String host, String tenant) {
        return _AUTHORIZE_ENDPOINT_TEMPLATE
            .replaceAll("{host}", host)
            .replaceAll("{tenant}", tenant);
    }

    static String getInstanceDiscoveryEndpoint(String host) {

        String discoveryHost = TRUSTED_HOSTS_SET.contains(host) ? host : _DEFAULT_TRUSTED_HOST;

        return _INSTANCE_DISCOVERY_ENDPOINT_TEMPLATE
            .replaceAll("{host}", discoveryHost);
    }

     static AadInstanceDiscoveryResponse sendInstanceDiscoveryRequest(Uri authorityUrl,
                                                                             MsalRequest msalRequest,
                                                                             ServiceBundle serviceBundle) {

        String instanceDiscoveryRequestUrl = getInstanceDiscoveryEndpoint(authorityUrl.authority) +
                _INSTANCE_DISCOVERY_REQUEST_PARAMETERS_TEMPLATE.replaceAll("{authorizeEndpoint}",
                        getAuthorizeEndpoint(authorityUrl.authority,
                                Authority.getTenant(authorityUrl, Authority.detectAuthorityType(authorityUrl))));

        HttpRequest httpRequest = new HttpRequest(
                HttpMethod.GET,
                instanceDiscoveryRequestUrl,
                msalRequest.headers().getReadonlyHeaderMap());

        HttpResponse httpResponse = HttpHelper.executeHttpRequest(
                httpRequest,
                msalRequest.requestContext(),
                serviceBundle);

        return JsonHelper.convertJsonToObject(httpResponse.body(), AadInstanceDiscoveryResponse.class);
    }

    static void doInstanceDiscoveryAndCache(Uri authorityUrl, bool validateAuthority, MsalRequest msalRequest, ServiceBundle serviceBundle) {

        AadInstanceDiscoveryResponse aadInstanceDiscoveryResponse = null;

        if(msalRequest.application().authenticationAuthority.authorityType.equals(AuthorityType.AAD)) {
            aadInstanceDiscoveryResponse = sendInstanceDiscoveryRequest(authorityUrl, msalRequest, serviceBundle);

            if (validateAuthority) {
                validate(aadInstanceDiscoveryResponse);
            }
        }

        cacheInstanceDiscoveryMetadata(authorityUrl.authority, aadInstanceDiscoveryResponse);
    }

    static void validate(AadInstanceDiscoveryResponse aadInstanceDiscoveryResponse) {
        if (StringHelper.isBlank(aadInstanceDiscoveryResponse.tenantDiscoveryEndpoint)) {
            throw new MsalServiceException(aadInstanceDiscoveryResponse);
        }
    }
}


