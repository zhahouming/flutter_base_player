part of 'index.dart';

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

class BaseTrack {
  String? id;
  String? title;
  String? language;
  dynamic raw;

  BaseTrack({
    this.id,
    this.title,
    this.language,
    this.raw,
  });
}
