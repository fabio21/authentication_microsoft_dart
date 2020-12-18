import 'instance_discovery_metadata_entry.dart';

class AadInstanceDiscoveryResponse {
  String tenantDiscoveryEndpoint;
  List<InstanceDiscoveryMetadataEntry> metadata;
  String errorDescription;
  List<int> errorCodes;
  String error;
  String correlationId;

  AadInstanceDiscoveryResponse({
    this.tenantDiscoveryEndpoint,
    this.metadata,
    this.errorDescription,
    this.errorCodes,
    this.error,
    this.correlationId,
  });

  factory AadInstanceDiscoveryResponse.fromJson(Map<String, dynamic> data) {
    return AadInstanceDiscoveryResponse(
      tenantDiscoveryEndpoint: data['tenant_discovery_endpoint'],
      metadata: data['metadata'] != null
          ? (data['metadata'] as List).map((e) => e).toList()
          : null,
      errorCodes: data['error_codes'] != null
          ? (data['error_codes'] as List).map((e) => e).toList()
          : null,
      errorDescription: data['error_description'],
      error: data['error'],
        correlationId: data['correlation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenant_discovery_endpoint'] = this.tenantDiscoveryEndpoint;
    data['metadata'] = this.metadata;
    data['error_codes'] = this.errorCodes;
    data['error_description'] = this.errorDescription;
    data['error'] = this.error;
    data['correlation_id'] = this.correlationId;
    return data;
  }
}
