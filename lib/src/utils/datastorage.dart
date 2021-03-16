class DataStorage {
  static final DataStorage dataStorage = DataStorage._internal();

  factory DataStorage() {
    return dataStorage;
  }

  DataStorage._internal();

  String _oauthCode;

  String get oauthCode => _oauthCode;

  set oauthCode(String value) {
    _oauthCode = value;
  }

  String autoLogin = "";
  String token = "";
//
//  String get token => _token;
//
//  set token(String value) {
//    _token = token;
//  }
}

final dataStorage = DataStorage();