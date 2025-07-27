import 'package:fpdart/fpdart.dart';

class EitherUtils {
  EitherUtils._();

  static R getRight<L, R>(Either<L, R> either) => either.getRight().getOrElse(() => throw ValueNotFoundException());
}

class ValueNotFoundException implements Exception {
  const ValueNotFoundException();

  @override
  String toString() {
    return "Right value not found in given either";
  }
}
