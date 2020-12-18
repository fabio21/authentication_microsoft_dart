class Collections {
  static final Collections _instance = Collections._internal();

  static List<String> _list = [];
  static Map<String, dynamic> _map = [];

  static List<String> singleton(String value){
    _list.add(value);
    return _list;
  }

  static  Map<String, dynamic> singletonMap(String key, dynamic value ){
    _map[key] = value;
    return _map;
  }

  factory Collections() {
    return _instance;
  }

  Collections._internal();
}