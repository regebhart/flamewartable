import 'package:flamewartable/bloc/gamepiece/gamepiece_bloc.dart';
import 'package:flamewartable/bloc/toolmenu/tool_menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game/game_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BrowserContextMenu.disableContextMenu();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ToolMenuBloc()),
        BlocProvider(create: (_) => GamePieceBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flame Wartable',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const GameWindowWidget(),
      ),
    );
  }
}
