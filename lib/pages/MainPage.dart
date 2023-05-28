import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:shortgpt_lite/cubit/gpt_chat_cubit.dart';
import 'package:shortgpt_lite/pages/SettingsPage.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:shortgpt_lite/resources/llm_settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final promptController = TextEditingController();
  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        forceMaterialTransparency: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.green,
                  Colors.blue,
                ],
              )),
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 2,
                    child: Image.asset("assets/images/shortgpt-logo.png",
                        height: 48, width: 48),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ShortGPT Lite',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Get short and concise answers from GPT',
                    style: TextStyle(
                        color: Color.fromARGB(255, 223, 223, 223),
                        fontSize: 12.0),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.auto_awesome,
              ),
              title: const Text('ShortGPT'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            AboutListTile(
              icon: const Icon(Icons.info),
              applicationIcon: Image.asset('assets/images/shortgpt-logo.png'),
              applicationName: 'ShortGPT Lite',
              applicationVersion: 'v1.0.0',
              applicationLegalese: '\u{a9} 2023 Rupesh Sreeraman',
              aboutBoxChildren: [
                const SizedBox(height: 24),
                Text(
                    "Get short and concise answers from GPT\nBased on large language model GPT \n\nProject page : https://rupeshsreeraman.itch.io/shortgpt")
              ],
            ),
          ],
        ),
      ),
      body: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Question :",
              )),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: TextField(
              controller: promptController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Explain quantum computing in simple terms',
              ),
              minLines: 2,
              maxLines: 3,
            )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: ButtonBar(buttonHeight: 50, children: <Widget>[
              _buildThinkButton(promptController),
            ])),
        _buildAnswer(),
      ]),
    );
  }
}

Widget _buildThinkButton(TextEditingController promptController) {
  return BlocBuilder<GptChatCubit, GptChatState>(builder: (context, state) {
    if (state is GptChatInitial ||
        state is GptChatResponse ||
        state is GptChatError) {
      return OutlinedButton.icon(
        label: Text("Think"),
        icon: const Icon(Icons.auto_awesome_outlined),
        style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll<Color>(Colors.white10),
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white12),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        onPressed: () {
          BlocProvider.of<GptChatCubit>(context)
              .ask(getModelInput(promptController.text));
          FocusManager.instance.primaryFocus?.unfocus();
        },
      );
    } else {
      return Container();
    }
  });
}

Widget _buildAnswer() {
  return BlocConsumer<GptChatCubit, GptChatState>(
      listener: (context, state) {},
      buildWhen: (context, state) {
        return state is GptChatStart ||
            state is GptChatResponse ||
            state is GptChatError;
      },
      builder: (context, state) {
        if (state is GptChatStart) {
          const colorizeColors = [
            Colors.purple,
            Colors.blue,
            Colors.yellow,
            Colors.red,
          ];
          const colorizeTextStyle = TextStyle(
            fontSize: 20.0,
            fontFamily: 'Horizon',
          );
          return Expanded(
              child: SizedBox(
                  child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Thinking...',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              )
            ],
            isRepeatingAnimation: true,
          )));
        } else if (state is GptChatResponse) {
          bool? isRenderMarkdown = Settings.getValue<bool>(
              "key-render-markdown",
              defaultValue: true);
          if (isRenderMarkdown!) {
            return Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: MarkdownWidget(
                        selectable: true,
                        data: state.llmResponse.answer!,
                        config: MarkdownConfig.darkConfig)));
          } else {
            return Expanded(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: SelectableText(state.llmResponse.answer!)));
          }
        } else if (state is GptChatError) {
          String errMsg = state.appError.message;
          return ExpansionTile(
            title: Text(
              "🛑 $errMsg",
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
            subtitle: const Text(' More details >>>',
                style: TextStyle(
                  color: Colors.grey,
                )),
            children: <Widget>[
              ListTile(
                  title: Text(state.appError.longMessage,
                      style: const TextStyle(
                        color: Colors.grey,
                      ))),
            ],
          );
        } else {
          return Container();
        }
      });
}
