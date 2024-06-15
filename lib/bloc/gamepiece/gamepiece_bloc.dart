import 'package:flame/extensions.dart';
import 'package:flamewartable/components/gamepiece_widget.dart';
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

    on<GamePieceSelected>(
      (event, emit) {
        var tokens = state.tokens.toList();
        var index = tokens.indexWhere((element) => element.spriteComponent == event.piece);
        if (index != -1) {
          tokens[index] = tokens[index].copyWith(selected: event.selected);
        }
        emit(state.copyWith(tokens: tokens));
      },
    );

    on<SelectGamePiecesInArea>(
      (event, emit) {
        var tokens = state.tokens.toList();
        for (var index = 0; index < tokens.length; index++) {
          GamePiece token = tokens[index].copyWith();
          //if within area, set true, otherwise false
          tokens[index] = token.copyWith(selected: event.area.containsPoint(token.spriteComponent.position));
        }
        emit(state.copyWith(tokens: tokens));
      },
    );

    on<ClearGamePieceSelections>(
      (event, emit) {
        var tokens = state.tokens.toList();
        for (var index = 0; index < tokens.length; index++) {
          GamePiece token = tokens[index].copyWith(selected: false);
          tokens[index] = token;
        }
        emit(state.copyWith(tokens: tokens));
      },
    );
  }
}
