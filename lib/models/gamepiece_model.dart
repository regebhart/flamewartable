import 'package:equatable/equatable.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class GamePiece extends Equatable {
  const GamePiece({
    required this.bodyComponent,
    // required this.status,
    required this.selected,
    // required this.rotation,
  });

  final BodyComponent bodyComponent;
  // final GamePieceStatus status;
  final bool selected;
  // double rotation;

  GamePiece copyWith({
    BodyComponent? spriteComponent,
    // GamePieceStatus? status,
    bool? selected,
  }) {
    return GamePiece(
      bodyComponent: spriteComponent ?? this.bodyComponent,
      // status: status ?? this.status,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object> get props => [bodyComponent, selected];
}
