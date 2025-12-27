import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/std_line.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';

class CodeView extends StatelessWidget {
  final List<StdLine> lines;
  final double fontSize;

  const CodeView({super.key, required this.lines, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: lines
            .map(
              (stdLine) => TextSpan(
                text: stdLine.line,
                style: context.typography.caption?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: fontSize,
                  color: stdLine.isError ? context.errorColor : null,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
