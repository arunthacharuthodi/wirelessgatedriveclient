import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<bool> get hasServerHost async =>
    await _secureStorage.containsKey(key: "server-host") &&
    (await serverhost != null || await serverhost == '');

Future<String?> get serverhost => _secureStorage.read(key: "server-host");

Future<void> setServerHost(String value) =>
    _secureStorage.write(key: "server-host", value: value);

Future deleteHost() => _secureStorage.delete(key: "server-host");
