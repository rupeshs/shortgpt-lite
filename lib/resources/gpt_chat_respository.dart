import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shortgpt_lite/constants/urls.dart';
import 'package:shortgpt_lite/constants/words.dart';
import 'package:shortgpt_lite/models/errors.dart';
import 'package:shortgpt_lite/models/gpt_chat_input.dart';
import 'package:shortgpt_lite/models/gpt_chat_output.dart';
import 'package:shortgpt_lite/models/llm_input.dart';
import 'package:shortgpt_lite/models/llm_response.dart';
import 'package:shortgpt_lite/resources/llm_chat_api.dart';

class GptChatRepository implements LlmChatApi {
  final Dio _dio = Dio();

  String getShortPrompt(String query) {
    String prompt = '''
    You are an expert assistant called shortgpt, your task is to give clear and correct answers to user's questions.
    You can use a maximum of $maxWords words. The generated text should be formatted with markdown.
    $query
    ''';
    return prompt;
  }

  String getLongPrompt(String query) {
    String prompt = '''
    You are an expert assistant called shortgpt, your task is to give clear and correct answers to user's questions.
    The generated text should be formatted with markdown.
    $query
    ''';
    return prompt;
  }

  @override
  Future<Either<AppError, LlmResponse>> getAnswer(LlmInput llmInput) async {
    String shortGptPrompt = "";
    if (llmInput.isLong!) {
      shortGptPrompt = getLongPrompt(llmInput.prompt!);
    } else {
      shortGptPrompt = getShortPrompt(llmInput.prompt!);
    }
    String? apiKey = llmInput.apiKey;
    String authorization = "Bearer $apiKey";

    //print(shortGptPrompt);

    final chatInput = GptChatInput(
      model: llmInput.model,
      messages: [
        Messages(role: "user", content: shortGptPrompt),
      ],
      temperature: llmInput.temperature,
    );

    //print(llmInput.toJson());

    final stopwatch = Stopwatch();
    try {
      Response response = await _dio.post(
        openaiChatCompletionURL,
        data: chatInput.toJson(),
        options: Options(
          headers: {"Authorization": authorization},
        ),
      );
      stopwatch.stop();
      final gptOutput = GptChatOutput.fromJson(response.data);
      LlmResponse llmResponse = LlmResponse(
          answer: gptOutput.choices?[0].message?.content,
          promptTokens: gptOutput.usage?.promptTokens,
          completionTokens: gptOutput.usage?.completionTokens,
          totalTokens: gptOutput.usage?.totalTokens,
          elapsedTime: stopwatch.elapsedMilliseconds.toDouble());

      return Right(llmResponse);
    } on DioError catch (e) {
      stopwatch.stop();
      return Left(_handleDioError(e));
    }
  }

  AppError _handleDioError(DioError err) {
    if (err.response != null) {
      String? errorMessage = err.response!.data["error"]["message"];
      if (err.response!.statusCode! == 401) {
        return AppError(
            AppErrorType.authError,
            "Error : ${err.response!.statusMessage} - [${err.response!.statusCode!}]",
            "Please set a valid API key in the settings.");
      } else if (err.response!.statusCode! >= 500) {
        return AppError(AppErrorType.serverError,
            "Server error [${err.response!.statusCode!}]", errorMessage!);
      } else {
        return AppError(
            AppErrorType.requestError,
            "Error : ${err.response!.statusMessage} - [${err.response!.statusCode!}]",
            errorMessage!);
      }
    } else {
      //print("DIO error" + err.message);
      return AppError(AppErrorType.requestSetupSend,
          "Network error,please check your internet.", err.error.toString());
    }
  }
}
