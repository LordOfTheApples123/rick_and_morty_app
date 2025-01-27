import 'package:flutter/material.dart';

typedef LoadingBuilder = Widget Function(BuildContext);
typedef DataBuilder<T> = Widget Function(BuildContext, T?);
typedef ErrorBuilder<T> = Widget Function(BuildContext, dynamic, T?);

class FutureUpdater<T> extends StatefulWidget {
  const FutureUpdater({
    super.key,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    required this.future,
  });

  final LoadingBuilder? loadingBuilder;
  final DataBuilder<T> builder;
  final ErrorBuilder<T>? errorBuilder;
  final Future<T> future;


  @override
  State<FutureUpdater<T>> createState() => _FutureUpdaterState<T>();
}

class _FutureUpdaterState<T> extends State<FutureUpdater<T>> {
  T? _data;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _throwFuture();
  }

  void _handleError(error) {
    setState(() {
      _error = error;
    });
  }

  void _handleValue(value){
    setState(() {
      _data = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    final errorBuilder = widget.errorBuilder;
    if (_error != null && errorBuilder != null) {
      return errorBuilder(context, _error, _data);
    }

    final loadingBuilder = widget.loadingBuilder;
    if (_data == null && loadingBuilder != null) {
      return loadingBuilder(context);
    }

    return widget.builder(context, _data);
  }

  void _throwFuture() {
    widget.future
        .then((_handleValue))
        .catchError(_handleError);
  }

  @override
  void didUpdateWidget(covariant FutureUpdater<T> oldWidget) {

    super.didUpdateWidget(oldWidget);
    if(oldWidget.future != widget.future){
      _throwFuture();
    }
  }


}
