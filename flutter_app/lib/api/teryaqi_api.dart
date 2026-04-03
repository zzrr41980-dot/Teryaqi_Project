import 'dart:convert';

import 'package:http/http.dart' as http;

class TeryaqiException implements Exception {
  TeryaqiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// عميل REST يطابق واجهات PHP في `Teryaqi-main/api/`.
class TeryaqiApi {
  TeryaqiApi(this.baseUrl);

  String baseUrl;

  Uri _uri(String path) {
    final b = baseUrl.replaceAll(RegExp(r'/$'), '');
    return Uri.parse('$b$path');
  }

  dynamic _decode(String body) {
    if (body.isEmpty) return null;
    return jsonDecode(body);
  }

  String _errorMessage(dynamic decoded, String fallback) {
    if (decoded is Map && decoded['message'] != null) {
      return decoded['message'].toString();
    }
    return fallback;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final r = await http.post(
      _uri('/api/patients/login.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 200) {
      throw TeryaqiException(_errorMessage(decoded, 'فشل تسجيل الدخول'));
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String nationalId,
    required String email,
    required String password,
    required String gender,
    String? dateOfBirth,
    String? phone,
  }) async {
    final body = <String, dynamic>{
      'full_name': fullName,
      'national_id': nationalId,
      'email': email,
      'password': password,
      'gender': gender,
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) 'date_of_birth': dateOfBirth,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };
    final r = await http.post(
      _uri('/api/patients/register.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 201) {
      throw TeryaqiException(_errorMessage(decoded, 'فشل إنشاء الحساب'));
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<List<Map<String, dynamic>>> getMedications(int patientId) async {
    final r = await http.get(
      _uri('/api/medications/get_for_patient.php?patient_id=$patientId'),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 200) {
      throw TeryaqiException(_errorMessage(decoded, 'تعذر جلب الأدوية'));
    }
    if (decoded is! List) {
      throw TeryaqiException('استجابة غير متوقعة');
    }
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<int> createMedication({
    required String name,
    String dosageForm = 'Tablet',
    String strength = '',
    String description = '',
  }) async {
    final r = await http.post(
      _uri('/api/medications/create_medications.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'medication_name': name,
        'dosage_form': dosageForm,
        'strength': strength,
        'description': description,
      }),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 201) {
      throw TeryaqiException(_errorMessage(decoded, 'تعذر إنشاء الدواء'));
    }
    final map = Map<String, dynamic>.from(decoded as Map);
    final id = map['medication_id'];
    if (id is int) return id;
    if (id is String) return int.parse(id);
    throw TeryaqiException('لا يوجد medication_id');
  }

  Future<int> addForPatient({
    required int patientId,
    required int medicationId,
    required String dosageAmount,
    String instructions = '',
    String? startDate,
  }) async {
    final r = await http.post(
      _uri('/api/medications/add_for_patient.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'patient_id': patientId,
        'medication_id': medicationId,
        'dosage_amount': dosageAmount,
        'instructions': instructions,
        if (startDate != null) 'start_date': startDate,
      }),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 201) {
      throw TeryaqiException(_errorMessage(decoded, 'تعذر ربط الدواء بالمريض'));
    }
    final map = Map<String, dynamic>.from(decoded as Map);
    final id = map['patient_medication_id'];
    if (id is int) return id;
    if (id is String) return int.parse(id);
    throw TeryaqiException('لا يوجد patient_medication_id');
  }

  Future<void> addSchedule({
    required int patientMedicationId,
    required String intakeTime,
    int frequencyPerDay = 1,
  }) async {
    var t = intakeTime;
    if (t.length == 5) t = '$t:00';
    final r = await http.post(
      _uri('/api/medications/add_schedule.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'patient_medication_id': patientMedicationId,
        'intake_time': t,
        'frequency_per_day': frequencyPerDay,
      }),
    );
    final decoded = _decode(r.body);
    if (r.statusCode != 201) {
      throw TeryaqiException(_errorMessage(decoded, 'تعذر حفظ وقت الجرعة'));
    }
  }
}
