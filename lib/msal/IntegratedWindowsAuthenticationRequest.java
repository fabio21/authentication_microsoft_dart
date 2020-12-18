// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

import msal.msal.MsalRequest;
import msal.request.RequestContext;

class IntegratedWindowsAuthenticationRequest extends MsalRequest {

    IntegratedWindowsAuthenticationRequest(IntegratedWindowsAuthenticationParameters parameters,
                                           PublicClientApplication application,
                                           RequestContext requestContext){
            super(application, createAuthenticationGrant(parameters), requestContext);
    }

    private static AbstractMsalAuthorizationGrant createAuthenticationGrant
            (IntegratedWindowsAuthenticationParameters parameters){

        return new IntegratedWindowsAuthorizationGrant(parameters.scopes(), parameters.username(), parameters.claims());
    }
}
