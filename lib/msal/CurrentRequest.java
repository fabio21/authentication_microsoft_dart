// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package msal;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Accessors(fluent = true)
class CurrentRequest {

    private final PublicApi publicApi;

    @Setter
    private boolean forceRefresh = false;

    CurrentRequest(PublicApi publicApi){
        this.publicApi = publicApi;
    }
}