import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';

class GamePiece extends Equatable {
  const GamePiece({
    required this.spriteComponent,
    // required this.status,
    required this.selected,
    // required this.rotation,
  });

  final SpriteComponent spriteComponent;
  // final GamePieceStatus status;
  final bool selected;
  // double rotation;

  GamePiece copyWith({
    SpriteComponent? spriteComponent,
    // GamePieceStatus? status,
    bool? selected,
  }) {
    return GamePiece(
      spriteComponent: spriteComponent ?? this.spriteComponent,
      // status: status ?? this.status,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object> get props => [spriteComponent, selected];
}
