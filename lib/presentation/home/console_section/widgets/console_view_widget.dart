import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/std_line.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/widgets/code_view.dart';

class ConsoleViewWidget extends StatefulWidget {
  const ConsoleViewWidget({
    super.key,
    required double consoleViewHeight,
    required FocusNode focusNode,
    required Stream<List<StdLine>>? selectedDeviceStream,
  }) : _consoleViewHeight = consoleViewHeight,
       _selectedDeviceStream = selectedDeviceStream,
       _focusNode = focusNode;

  final double _consoleViewHeight;
  final Stream<List<StdLine>>? _selectedDeviceStream;
  final FocusNode _focusNode;

  @override
  State<ConsoleViewWidget> createState() => _ConsoleViewWidgetState();
}

class _ConsoleViewWidgetState extends State<ConsoleViewWidget> {
  final _scrollController = ScrollController();
  double _fontSize = 13;

  @override
  void initState() {
    super.initState();
    widget._focusNode.addListener(_scrollToBottom);
  }

  @override
  void dispose() {
    widget._focusNode.removeListener(_scrollToBottom);
    super.dispose();
  }

  void _scrollToBottom() {
    try {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: context.theme.fasterAnimationDuration,
        curve: context.theme.animationCurve,
      );
    } on AssertionError catch (e, stack) {
      // ignore not attached error
      if (kDebugMode) {
        print(e);
        debugPrintStack(stackTrace: stack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.resources.solidBackgroundFillColorTertiary,
      height: widget._consoleViewHeight,
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(4),
      child: StreamBuilder(
        stream: widget._selectedDeviceStream,
        builder: (BuildContext context, AsyncSnapshot<List<StdLine>> snapshot) {
          if (snapshot.hasData) {
            _scrollToBottom();
            return SingleChildScrollView(
              controller: _scrollController,
              child: KeyboardListener(
                focusNode: widget._focusNode,
                onKeyEvent: (KeyEvent event) {
                  if (event is KeyDownEvent) {
                    if ((HardwareKeyboard.instance.isControlPressed || HardwareKeyboard.instance.isMetaPressed) &&
                        event.logicalKey == LogicalKeyboardKey.add &&
                        _fontSize < 24) {
                      setState(() => _fontSize++);
                    } else if ((HardwareKeyboard.instance.isControlPressed ||
                            HardwareKeyboard.instance.isMetaPressed) &&
                        event.logicalKey == LogicalKeyboardKey.minus &&
                        _fontSize > 8) {
                      setState(() => _fontSize--);
                    }
                  }
                },
                child: CodeView(lines: snapshot.data ?? [], fontSize: _fontSize),
              ),
            );
          } else if (snapshot.hasError) {
            return Icon(WindowsIcons.error);
          } else {
            return Center(child: ProgressRing());
          }
        },
      ),
    );
  }
}
