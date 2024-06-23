import 'dart:math';

import 'package:flame/components.dart';
import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flamewartable/components/gamepiece_widget.dart';
import 'package:flamewartable/models/gamepiece_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/toolmenu/tool_menu_bloc.dart';

List<double> sizes = [30, 40, 50, 80, 120];

class ToolMenuWidget extends StatefulWidget {
  const ToolMenuWidget({super.key});

  @override
  State<ToolMenuWidget> createState() => _ToolMenuWidgetState();
}

class _ToolMenuWidgetState extends State<ToolMenuWidget> {
  @override
  Widget build(BuildContext context) {
    final toolMenu = BlocProvider.of<ToolMenuBloc>(context);
    final gamePieces = BlocProvider.of<GamePieceBloc>(context);

    return BlocBuilder<ToolMenuBloc, String>(builder: (context, tool) {
      return Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10, bottom: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                toolMenu.add(ToolSelected(tool: 'pan'));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.black),
                    color: tool == 'pan' ? Colors.orange : Colors.grey.shade200,
                  ),
                  child: const Icon(
                    Icons.pan_tool,
                    size: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: GestureDetector(
                onTap: () {
                  toolMenu.add(ToolSelected(tool: 'select'));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.black),
                      color: tool == 'select' ? Colors.orange : Colors.grey.shade200,
                    ),
                    child: const Icon(
                      Icons.pan_tool_alt,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: GestureDetector(
                onTap: () {
                  int randomIndex = Random().nextInt(sizes.length);
                  
                  gamePieces.add(AddGamePiece(
                    piece: GamePiece(
                        selected: false,
                        // status: GamePieceStatus.initial,
                        spriteComponent: GamePieceComponent(
                          
                          spriteImage: 'token.png',
                          toolMenuBloc: toolMenu,
                          gamePieceBloc: gamePieces,
                          
                        )
                          ..priority = 50
                          ..width = sizes[randomIndex]
                          ..height = sizes[randomIndex]
                          ..position = Vector2(60, 60)
                          ..anchor = Anchor.center)
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.black),
                      color: Colors.green.shade300,
                    ),
                    child: const Icon(
                      Icons.circle,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
