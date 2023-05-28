//Abstract class for LLM chat data repository
import 'package:dartz/dartz.dart';
import 'package:shortgpt_lite/models/errors.dart';
import 'package:shortgpt_lite/models/llm_input.dart';
import 'package:shortgpt_lite/models/llm_response.dart';

abstract class LlmChatApi {
  Future<Either<AppError, LlmResponse>> getAnswer(LlmInput llmInput);
}
