sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please try again.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'The server could not complete the request.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'No saved news is available.',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
