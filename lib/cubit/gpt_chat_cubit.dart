import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shortgpt_lite/models/errors.dart';
import 'package:shortgpt_lite/models/llm_input.dart';
import 'package:shortgpt_lite/models/llm_response.dart';
import 'package:shortgpt_lite/resources/llm_chat_api.dart';
part 'gpt_chat_state.dart';

class GptChatCubit extends Cubit<GptChatState> {
  final LlmChatApi apiRepository;

  GptChatCubit({required this.apiRepository}) : super(GptChatInitial());

  void ask(LlmInput llmInput) async {
    if (llmInput.prompt == "") {
      AppError appError = AppError(
          AppErrorType.emptyPrompt,
          "Error : empty question!",
          "Ask anything to shortGPT for example, which is the capital of India?");
      emit(GptChatError(appError));
      return;
    }
    if (llmInput.apiKey == "") {
      AppError appError = AppError(
          AppErrorType.emptyPrompt,
          "Please set your OpenAI API key in settings!",
          "Get your OpenAI API key from https://platform.openai.com/");
      emit(GptChatError(appError));
      return;
    }

    emit(GptChatStart());

    Either<AppError, LlmResponse> result =
        await apiRepository.getAnswer(llmInput);

    result.fold((failure) {
      emit(GptChatError(failure));
    }, (llmResponse) {
      emit(GptChatResponse(llmResponse));
    });
  }
}
