class UserSession {
  static String? studentId;
  static String? role;
  static String? department;
  static String? position;

  static void setFromResponse(Map<String, dynamic> res) {
    studentId = (res['student_id'] ?? res['studentId'] ?? res['id'] ?? '').toString();
    role = (res['role'] ?? '').toString();
    department = (res['department'] ?? '').toString();
    position = (res['position'] ?? '').toString();
  }

  static void clear() {
    studentId = null;
    role = null;
    department = null;
    position = null;
  }
}
