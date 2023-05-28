part of 'gpt_chat_cubit.dart';

abstract class GptChatState extends Equatable {
  const GptChatState();

  @override
  List<Object> get props => [];
}

class GptChatInitial extends GptChatState {}

class GptChatError extends GptChatState {
  final AppError appError;
  const GptChatError(this.appError);
  @override
  List<Object> get props => [appError];
}

class GptChatStart extends GptChatState {}

class GptChatResponse extends GptChatState {
  final LlmResponse llmResponse;
  const GptChatResponse(this.llmResponse);
  @override
  List<Object> get props => [llmResponse];
}
