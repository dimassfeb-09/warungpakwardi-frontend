class ResponseAPI<T> {
  final String message;
  final T? data;

  ResponseAPI({required this.message, this.data});

  factory ResponseAPI.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonData,
  ) {
    return ResponseAPI(
      message: json['message'],
      data:
          fromJsonData != null && json.containsKey('data')
              ? fromJsonData(json['data'])
              : null,
    );
  }
}
