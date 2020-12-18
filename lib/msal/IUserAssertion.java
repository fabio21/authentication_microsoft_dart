// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

/**
 * Interface representing a delegated user identity used by downstream applications in On-Behalf-Of flow
 */
public interface IUserAssertion {

    /**
     * Gets the assertion.
     *
     * @return string value
     */
    String getAssertion();
}
