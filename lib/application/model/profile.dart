import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Profile extends Equatable {
  @Id()
  int id = 0;
  String? name;

  @Transient()
  Map<String, dynamic> args = {};

  Profile copyWith({String? name, Map<String, dynamic>? args}) {
    return Profile()
      ..id = id
      ..name = name ?? this.name
      ..args = args ?? this.args;
  }

  String get dbArgs {
    return jsonEncode(args);
  }

  set dbArgs(String value) {
    args = jsonDecode(value);
  }

  @override
  List<Object?> get props => [id];
}
