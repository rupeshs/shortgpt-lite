import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:shortgpt_lite/models/gpt_models.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          TextInputSettingsTile(
            title: 'OpenAI API key',
            settingKey: 'key-openai-api-key',
            obscureText: true,
            borderColor: Colors.blueAccent,
            errorColor: Colors.deepOrangeAccent,
          ),
          RadioModalSettingsTile<String>(
            title: 'Model',
            settingKey: 'key-gpt-model',
            values: gptModels,
            selected: "gpt-3.5-turbo",
          ),
          SwitchSettingsTile(
            settingKey: 'key-long-mode',
            title: 'Long Mode,longer output text > 50 words',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            defaultValue: false,
          ),
          SliderSettingsTile(
            title: 'Temperature',
            settingKey: 'key-temperature',
            defaultValue: 0.7,
            min: 0,
            max: 2.0,
            step: 0.1,
            //leading: Icon(Icons.flame),
            onChange: (value) {},
          ),
          SwitchSettingsTile(
            settingKey: 'key-render-markdown',
            title: 'Render markdown',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            defaultValue: true,
          )
        ],
      ),
    );
  }
}
