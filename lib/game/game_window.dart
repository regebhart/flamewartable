import 'package:flame/game.dart';
import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/toolmenu/tool_menu_bloc.dart';
import '../components/toolmenu/toolmenu_widget.dart';
import 'game.dart';

class GameWindowWidget extends StatefulWidget {
  const GameWindowWidget({super.key});

  @override
  State<GameWindowWidget> createState() => _GameWindowWidgetState();
}

class _GameWindowWidgetState extends State<GameWindowWidget> {
  @override
  Widget build(BuildContext context) {
    final toolMenu = BlocProvider.of<ToolMenuBloc>(context);
    final gamePieces = BlocProvider.of<GamePieceBloc>(context);

    WartableGame game = WartableGame(
      toolMenuBloc: toolMenu,
      gamePieceBloc: gamePieces,
    );

    return Stack(
      children: [
        RawGestureDetector(
          excludeFromSemantics: false,
          gestures: {
            PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
              () => PanGestureRecognizer(
                debugOwner: this,
                allowedButtonsFilter: (int buttons) => buttons & kSecondaryButton != 0,
              ),
              (PanGestureRecognizer instance) {
                instance
                  ..dragStartBehavior = DragStartBehavior.down
                  ..onStart = (DragStartDetails details) {}
                  ..onUpdate = (DragUpdateDetails details) {
                    game.onSecondaryButtonDragUpdate(details);
                  }
                  ..onEnd = (DragEndDetails details) {};
              },
            ),
          },
          child: GameWidget(game: game),
        ),
        const ToolMenuWidget(),
      ],
    );
  }
}
