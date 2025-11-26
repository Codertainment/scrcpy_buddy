import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/arguments/video/video_bit_rate.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';

enum BitRateUnit {
  Kbps('K'),
  Mbps('M');

  const BitRateUnit(this.unitValue);

  final String unitValue;
}

class BitRateConfig extends StatefulWidget {
  const BitRateConfig({super.key});

  @override
  State<BitRateConfig> createState() => _BitRateConfigState();
}

class _BitRateConfigState extends State<BitRateConfig> {
  final _arg = VideoBitRate();
  late final _profilesBloc = context.read<ProfilesBloc>();
  BitRateUnit selectedUnit = BitRateUnit.Mbps;
  String? value;

  @override
  void initState() {
    super.initState();
    _onBlocStateChange(_profilesBloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        setState(() {
          _onBlocStateChange(state);
        });
      },
      builder: (context, state) {
        return Row(
          children: [
            ConfigTextBox(maxWidth: 100, value: value, isNumberOnly: true, onChanged: _onValueChanged),
            const SizedBox(width: 4),
            ComboBox<BitRateUnit>(
              value: selectedUnit,
              items: BitRateUnit.values
                  .map((unit) => ComboBoxItem(value: unit, child: Text(unit.name)))
                  .toList(growable: false),
              onChanged: _onUnitChanged,
            ),
          ],
        );
      },
    );
  }

  void _onBlocStateChange(ProfilesState state) {
    final bitRateValue = state.getFor<String>(_arg);
    if (bitRateValue != null) {
      selectedUnit = BitRateUnit.values.firstWhere((unit) => bitRateValue.endsWith(unit.unitValue));
      value = bitRateValue.substring(0, bitRateValue.length - 1);
    }
  }

  void _onUnitChanged(BitRateUnit? unit) {
    if (unit == null) return;
    setState(() {
      selectedUnit = unit;
    });
    if (value != null) {
      _updateValue(value!, unit);
    }
  }

  void _onValueChanged(String? value) {
    setState(() {
      this.value = value;
    });
    if (value == null) {
      _profilesBloc.add(UpdateProfileArgEvent(_arg, null));
    } else {
      _updateValue(value, selectedUnit);
    }
  }

  void _updateValue(String value, BitRateUnit unit) =>
      _profilesBloc.add(UpdateProfileArgEvent(_arg, "$value${unit.unitValue}"));
}
