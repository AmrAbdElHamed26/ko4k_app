
import 'error_netwrok_message_error.dart';

class ServerException implements Exception{

  // take error model and throw it
  final ErrorNetworkMessageError errorNetworkMessageError ;

  const ServerException({required this.errorNetworkMessageError});

}

class LocalDataBaseException implements Exception{
  final String message ;

  const LocalDataBaseException({required this.message});

}


class RemoteDataBaseException implements Exception{
  final String message ;

  const RemoteDataBaseException({required this.message});

}