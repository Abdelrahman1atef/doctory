class GenericResponse {
  dynamic status;
  String? message;
  dynamic data;

  GenericResponse({this.status, this.message, this.data});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}
