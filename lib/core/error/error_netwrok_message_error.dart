class ErrorNetworkMessageError {
  final String statusMessage;
  final int statusCode;
  final bool success;

  const ErrorNetworkMessageError({required this.statusMessage, required this.statusCode,required this.success});

  factory ErrorNetworkMessageError.fromJson(json)=>ErrorNetworkMessageError(
      statusMessage: json["statusMessage"],
      statusCode: json["statusCode"],
      success: json["success"]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ErrorNetworkMessageError &&
              runtimeType == other.runtimeType &&
              success == other.success;

  @override
  int get hashCode => success.hashCode;
}