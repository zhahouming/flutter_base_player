// ignore_for_file: prefer_final_fields

part of 'index.dart';

mixin _InternalMixin {
  bool _isInitialized = false;
  bool _isLooping = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<String> _errorLogs = [];

  bool _isLoading = false;

  final ChangeNotifier _eventStream = ChangeNotifier();

  final ChangeNotifier _precompleteStream = ChangeNotifier();
}
