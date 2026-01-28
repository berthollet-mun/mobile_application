class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final String? error;
  final String? code;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
    this.code,
  });

  factory ApiResponse.success({String? message, dynamic data}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.error(String error, {String? code}) {
    return ApiResponse(success: false, error: error, code: code);
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
      if (error != null) 'error': error,
      if (code != null) 'code': code,
    };
  }
}
