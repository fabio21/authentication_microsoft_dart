// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

interface ITelemetryManager {
    String generateRequestId();

    TelemetryHelper createTelemetryHelper(String requestId,
                                          String clientId,
                                          Event event,
                                          Boolean shouldFlush);
}
