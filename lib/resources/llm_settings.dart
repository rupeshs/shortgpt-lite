import 'package:shortgpt_lite/models/llm_input.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

LlmInput getModelInput(String query) {
  String? apiKey =
      Settings.getValue<String>("key-openai-api-key", defaultValue: "");
  bool? isLong = Settings.getValue<bool>("key-long-mode", defaultValue: false);
  double? temperature =
      Settings.getValue<double>("key-temperature", defaultValue: 0.7);
  String? curGptModel =
      Settings.getValue<String>("key-gpt-model", defaultValue: "gpt-3.5-turbo");
  LlmInput llmInput = LlmInput(
    apiKey: apiKey,
    model: curGptModel,
    prompt: query,
    temperature: temperature,
    isLong: isLong,
  );
  return llmInput;
}
