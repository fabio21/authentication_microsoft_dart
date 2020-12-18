// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

import lombok.Builder;
import lombok.Getter;
import lombok.experimental.Accessors;
import msal.account.IAccount;

/**
 * Context in which the the token cache is accessed
 *
 * For more details, see https://aka.ms/msal4j-token-cache
 */
@Builder
@Accessors(fluent = true)
@Getter
public class TokenCacheAccessContext implements ITokenCacheAccessContext {

    private ITokenCache tokenCache;

    private String clientId;

    private IAccount account;

    private boolean hasCacheChanged;
}
