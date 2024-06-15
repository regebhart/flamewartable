part of 'gamepiece_bloc.dart';

sealed class GamePieceEvent extends Equatable {
  const GamePieceEvent();

  @override
  List<Object> get props => [];
}

final class AddGamePiece extends GamePieceEvent {
  const AddGamePiece({required this.piece});

  final GamePiece piece;

    @override
  List<Object> get props => [piece];
}
