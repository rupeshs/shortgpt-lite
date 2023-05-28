import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shortgpt_lite/cubit/gpt_chat_cubit.dart';
import 'package:shortgpt_lite/models/llm_input.dart';
import 'package:shortgpt_lite/models/llm_response.dart';
import 'package:shortgpt_lite/resources/llm_chat_api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'gpt_chat_cubit_test.mocks.dart';

@GenerateMocks([LlmChatApi])
void main() {
  late MockLlmChatApi mockLlmChatApiRespository; //Mock API
  late GptChatCubit gptChatCubit;

  setUp(() {
    mockLlmChatApiRespository = MockLlmChatApi();
    gptChatCubit = GptChatCubit(apiRepository: mockLlmChatApiRespository);
  });

  tearDown(() {
    gptChatCubit.close();
  });

  test('cubit should have initial state as GptChatInitial', () {
    expect(gptChatCubit.state.runtimeType, GptChatInitial);
  });

  blocTest(
    "cubit should check empty prompt and emit GptChatError ",
    build: () => gptChatCubit,
    act: (GptChatCubit cubit) {
      cubit.ask(LlmInput(
          apiKey: "test-api-key",
          prompt: "",
          model: "gpt",
          temperature: 0.7,
          isLong: false));
    },
    expect: () => [isA<GptChatError>()],
  );

  blocTest(
    "cubit should check empty API key and emit GptChatError ",
    build: () => gptChatCubit,
    act: (GptChatCubit cubit) {
      cubit.ask(LlmInput(
          apiKey: "",
          prompt: "hello",
          model: "gpt",
          temperature: 0.7,
          isLong: false));
    },
    expect: () => [isA<GptChatError>()],
  );

  blocTest(
    "getAnswer should emit GPT response on success",
    build: () {
      return gptChatCubit;
    },
    act: (GptChatCubit cubit) async {
      LlmInput llmInput = LlmInput(
          apiKey: "test-api-key",
          prompt: "hello",
          model: "gpt",
          temperature: 0.7,
          isLong: false);
      when(mockLlmChatApiRespository.getAnswer(llmInput)).thenAnswer(
          (_) async => Right(LlmResponse(
              answer: "hello ",
              promptTokens: 10,
              completionTokens: 20,
              totalTokens: 100,
              elapsedTime: 0.5)));
      cubit.ask(llmInput);
    },
    expect: () => [isA<GptChatStart>(), isA<GptChatResponse>()],
    verify: (GptChatCubit cubit) {
      verify(mockLlmChatApiRespository.getAnswer(any)).called(1);
    },
  );
}
