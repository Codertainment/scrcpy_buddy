import 'dart:io';

class ProcessExceptionFixture {
  ProcessExceptionFixture._();

  static ProcessException create({String message = ""}) => ProcessException("", [], message);
}
