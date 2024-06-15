part of 'gamepiece_bloc.dart';

enum GamePieceStatus { initial, added, deleted }

final class GamePieceState extends Equatable {
  const GamePieceState({
    this.tokens = const <GamePiece>[],
  });

  final List<GamePiece> tokens;

  GamePieceState copyWith({
    List<GamePiece>? tokens,
  }) {
    return GamePieceState(
      tokens: tokens ?? this.tokens,
    );
  }

  @override
  List<Object> get props => [tokens];
}
