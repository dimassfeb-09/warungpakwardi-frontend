class ResponseErrorAPI {
  final String message;

  ResponseErrorAPI({required this.message});

  factory ResponseErrorAPI.fromJson(Map<String, dynamic> json) {
    return ResponseErrorAPI(message: json['message']);
  }
}
