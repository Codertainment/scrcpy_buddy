import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';

typedef ScrcpyResult = Either<ScrcpyError, Process>;
typedef ScrcpyStopResult = Either<ScrcpyError, bool>;