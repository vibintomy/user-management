import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Only imported on Web (safe)
import 'dart:html' as html;

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  /// Write value
  Future<void> write(String key, String value) async {
    if (kIsWeb) {
      html.window.localStorage[key] = value;
      return;
    }
    await _storage.write(key: key, value: value);
  }

  /// Read value
  Future<String?> read(String key) async {
    if (kIsWeb) {
      return html.window.localStorage[key];
    }
    return await _storage.read(key: key);
  }

  /// Delete key
  Future<void> delete(String key) async {
    if (kIsWeb) {
      html.window.localStorage.remove(key);
      return;
    }
    await _storage.delete(key: key);
  }

  /// Clear all storage
  Future<void> deleteAll() async {
    if (kIsWeb) {
      html.window.localStorage.clear();
      return;
    }
    await _storage.deleteAll();
  }
}
