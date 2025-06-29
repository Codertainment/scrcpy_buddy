import 'package:meta/meta.dart';
import 'package:parameterized_test/parameterized_test.dart';

@isTestGroup
void descriptionParameterizedTest(String groupDescription, List<List<dynamic>> values, Function body) {
  parameterizedTest(
    groupDescription,
    values,
    body,
    customDescriptionBuilder: (_, index, parameters) => '[$index] ${parameters[0]}',
  );
}
