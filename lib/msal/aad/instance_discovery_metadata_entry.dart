class InstanceDiscoveryMetadataEntry {
  String preferredNetwork;
  String preferredCache;
  List<String> aliases;

  InstanceDiscoveryMetadataEntry(
      {this.preferredNetwork, this.preferredCache, this.aliases});

  factory InstanceDiscoveryMetadataEntry.fromJson(Map<String, dynamic> data) {
    return InstanceDiscoveryMetadataEntry(
        preferredCache: data['preferred_cache'],
        preferredNetwork: data['preferred_network'],
        aliases: data['aliases'],
    );
  }

  Map<String, dynamic> toJson(){
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['preferred_cache'] = this.preferredCache;
      data['preferred_network'] = this.preferredNetwork;
      data['aliases'] = this.aliases;
      return data;
  }
}
