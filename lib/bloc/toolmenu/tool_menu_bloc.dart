import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ToolSelectedEvent {}

final class ToolSelected extends ToolSelectedEvent {
  String tool;

  ToolSelected({required this.tool});
}

class ToolMenuBloc extends Bloc<ToolSelectedEvent, String> {
  ToolMenuBloc() : super('pan') {
    on<ToolSelected>((event, emit) => emit(event.tool));
  }
}
