import 'package:flutter/foundation.dart';

/// عنوان الخادم الافتراضي حسب المنصة (المحاكي Android يستخدم 10.0.2.2 بدل localhost).
String defaultApiBaseUrl() {
  if (kIsWeb) return 'http://localhost:8080';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8080';
  }
  return 'http://127.0.0.1:8080';
}
