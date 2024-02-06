class ServiceCallback {
  final bool success;
  final String msg;
  final String? techMsg;
  final bool? isNotLogin;
  final dynamic data;

  ServiceCallback({
    required this.success,
    required this.msg,
    this.techMsg,
    this.isNotLogin,
    this.data,
  });
}
