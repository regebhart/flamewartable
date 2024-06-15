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

final class GamePieceSelected extends GamePieceEvent {
  const GamePieceSelected({required this.piece, required this.selected});

  final GamePieceComponent piece;
  final bool selected;

  @override
  List<Object> get props => [piece, selected];
}

final class SelectGamePiecesInArea extends GamePieceEvent {
  const SelectGamePiecesInArea({required this.area});

  final Rect area;

  @override
  List<Object> get props => [area];
}

final class ClearGamePieceSelections extends GamePieceEvent {
  const ClearGamePieceSelections();
}
