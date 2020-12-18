// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

/**
 * Interface representing operation of executing code before and after cache access.
 *
 * For more details, see https://aka.ms/msal4j-token-cache
 */
public interface ITokenCacheAccessAspect {

    void beforeCacheAccess(ITokenCacheAccessContext iTokenCacheAccessContext);

    void afterCacheAccess(ITokenCacheAccessContext iTokenCacheAccessContext);
}
