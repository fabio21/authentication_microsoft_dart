// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

import lombok.Getter;
import lombok.experimental.Accessors;
import msal.authority.Authority;
import msal.msal.MsalRequest;
import msal.request.RequestContext;

import java.net.MalformedURLException;
import java.net.URL;

@Accessors(fluent = true)
@Getter
class SilentRequest extends MsalRequest {

    private SilentParameters parameters;

    private Authority requestAuthority;

    SilentRequest(SilentParameters parameters,
                  AbstractClientApplicationBase application,
                  RequestContext requestContext) throws MalformedURLException {

        super(application, null, requestContext);

        this.parameters = parameters;
        this.requestAuthority = StringHelper.isBlank(parameters.authorityUrl()) ?
                application.authenticationAuthority :
                Authority.createAuthority(new URL(parameters.authorityUrl()));

        application.getServiceBundle().getServerSideTelemetry().getCurrentRequest().forceRefresh(
                parameters.forceRefresh());
    }
}
