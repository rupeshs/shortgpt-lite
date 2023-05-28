import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortgpt_lite/cubit/gpt_chat_cubit.dart';
import 'package:shortgpt_lite/pages/MainPage.dart';
import 'package:shortgpt_lite/resources/gpt_chat_respository.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(550, 600),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  initAppSettings();
  runApp(const MyApp());
}

void initAppSettings() async {
  await Settings.init();
  //Settings.clearCache();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  GptChatCubit(apiRepository: GptChatRepository())),
        ],
        child: MaterialApp(
          title: 'ShortGPT Lite',
          theme: ThemeData.dark(),
          home: MainPage(title: ""),
        ));
  }
}
