import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _token = "token";
  static const String _id = "id";
  static const String _email = "email";
  static const String _name = "name";

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _token, value: token);
  }

  Future<String?> getToken() async {
    return (await _secureStorage.read(key: _token))?.toString();
  }

  Future<void> saveId(String id) async {
    await _secureStorage.write(key: _id, value: id);
  }

  Future<String?> getId() async {
    return (await _secureStorage.read(key: _id))?.toString();
  }

  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: _email, value: email);
  }

  Future<String?> getEmail() async {
    return (await _secureStorage.read(key: _email))?.toString();
  }

  Future<void> saveName(String name) async {
    await _secureStorage.write(key: _name, value: name);
  }

  Future<String?> getName() async {
    return (await _secureStorage.read(key: _name))?.toString();
  }

  Future<void> logout() {
    return _secureStorage.deleteAll();
  }
}
