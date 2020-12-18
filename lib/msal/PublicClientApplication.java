// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

import com.nimbusds.oauth2.sdk.auth.ClientAuthentication;
import com.nimbusds.oauth2.sdk.auth.ClientAuthenticationMethod;
import com.nimbusds.oauth2.sdk.id.ClientID;
import org.slf4j.LoggerFactory;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.atomic.AtomicReference;

import msal.authentication.IAuthenticationResult;

import static com.microsoft.aad.msal4j.ParameterValidationUtils.validateNotBlank;
import static com.microsoft.aad.msal4j.ParameterValidationUtils.validateNotNull;

/**
 * Class to be used to acquire tokens for public client applications (Desktop, Mobile).
 * For details see {@link IPublicClientApplication}
 * 
 * Conditionally thread-safe
 */
public class PublicClientApplication extends AbstractClientApplicationBase implements IPublicClientApplication {

    private final ClientAuthenticationPost clientAuthentication;

    @Override
    public CompletableFuture<IAuthenticationResult> acquireToken(UserNamePasswordParameters parameters) {

        validateNotNull("parameters", parameters);

        UserNamePasswordRequest userNamePasswordRequest =
                new UserNamePasswordRequest(parameters,
                        this,
                        createRequestContext(PublicApi.ACQUIRE_TOKEN_BY_USERNAME_PASSWORD, parameters));

        return this.executeRequest(userNamePasswordRequest);
    }

    @Override
    public CompletableFuture<IAuthenticationResult> acquireToken(IntegratedWindowsAuthenticationParameters parameters) {

        validateNotNull("parameters", parameters);

        IntegratedWindowsAuthenticationRequest integratedWindowsAuthenticationRequest =
                new IntegratedWindowsAuthenticationRequest(
                        parameters,
                        this,
                        createRequestContext(
                                PublicApi.ACQUIRE_TOKEN_BY_INTEGRATED_WINDOWS_AUTH, parameters));

        return this.executeRequest(integratedWindowsAuthenticationRequest);
    }

    @Override
    public CompletableFuture<IAuthenticationResult> acquireToken(DeviceCodeFlowParameters parameters) {

        if (!(AuthorityType.AAD.equals(authenticationAuthority.authorityType()) ||
                AuthorityType.ADFS.equals(authenticationAuthority.authorityType()))) {
            throw new IllegalArgumentException(
                    "Invalid authority type. Device Flow is only supported by AAD and ADFS authorities");
        }

        validateNotNull("parameters", parameters);

        AtomicReference<CompletableFuture<IAuthenticationResult>> futureReference =
                new AtomicReference<>();

        DeviceCodeFlowRequest deviceCodeRequest = new DeviceCodeFlowRequest(
                parameters,
                futureReference,
                this,
                createRequestContext(PublicApi.ACQUIRE_TOKEN_BY_DEVICE_CODE_FLOW, parameters));

        CompletableFuture<IAuthenticationResult> future = executeRequest(deviceCodeRequest);
        futureReference.set(future);
        return future;
    }

    @Override
    public CompletableFuture<IAuthenticationResult> acquireToken(InteractiveRequestParameters parameters){

        validateNotNull("parameters", parameters);

        AtomicReference<CompletableFuture<IAuthenticationResult>> futureReference = new AtomicReference<>();

        InteractiveRequest interactiveRequest = new InteractiveRequest(
                parameters,
                futureReference,
                this,
                createRequestContext(PublicApi.ACQUIRE_TOKEN_INTERACTIVE, parameters));

        CompletableFuture<IAuthenticationResult> future = executeRequest(interactiveRequest);
        futureReference.set(future);
        return future;
    }

    private PublicClientApplication(Builder builder) {
        super(builder);
        validateNotBlank("clientId", clientId());
        log = LoggerFactory.getLogger(PublicClientApplication.class);
        this.clientAuthentication = new ClientAuthenticationPost(ClientAuthenticationMethod.NONE,
                new ClientID(clientId()));
    }

    @Override
    protected ClientAuthentication clientAuthentication() {
        return clientAuthentication;
    }

    /**
     * @param clientId Client ID (Application ID) of the application as registered
     *                 in the application registration portal (portal.azure.com)
     * @return instance of Builder of PublicClientApplication
     */
    public static Builder builder(String clientId) {

        return new Builder(clientId);
    }

    public static class Builder extends AbstractClientApplicationBase.Builder<Builder> {

        private Builder(String clientId) {
            super(clientId);
        }

        @Override
        public PublicClientApplication build() {

            return new PublicClientApplication(this);
        }

        @Override
        protected Builder self() {
            return this;
        }
    }
}