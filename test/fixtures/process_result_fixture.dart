import 'dart:io';

class ProcessResultFixture {
  ProcessResultFixture._();

  static ProcessResult create({int exitCode = 0, String stdout = "", String stderr = ""}) =>
      ProcessResult(0, exitCode, stdout, stderr);
}
