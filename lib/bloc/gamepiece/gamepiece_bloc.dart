import 'package:flamewartable/models/gamepiece_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'gamepiece_state.dart';
part 'gamepiece_events.dart';

class GamePieceBloc extends Bloc<GamePieceEvent, GamePieceState> {
  GamePieceBloc() : super(const GamePieceState()) {
    on<AddGamePiece>(
      (event, emit) {
        var tokens = state.tokens.toList();
        tokens.add(event.piece);
        emit(state.copyWith(tokens: tokens));
      },
    );
  }
}
