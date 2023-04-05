import 'package:flutter/widgets.dart';

class ChangeNotifierBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final ChangeNotifier notifier;
  const ChangeNotifierBuilder({
    Key? key,
    required this.builder,
    required this.notifier,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangeNotifierBuilderState createState() => _ChangeNotifierBuilderState();
}

class _ChangeNotifierBuilderState extends State<ChangeNotifierBuilder> {
  update() {
    setState(() {});
  }

  @override
  void initState() {
    widget.notifier.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
