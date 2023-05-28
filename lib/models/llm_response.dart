class LlmResponse {
  String? answer;
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;
  double? elapsedTime;

  LlmResponse(
      {this.answer,
      this.promptTokens,
      this.completionTokens,
      this.totalTokens,
      this.elapsedTime});

  LlmResponse.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    promptTokens = json['prompt_tokens'];
    completionTokens = json['completion_tokens'];
    totalTokens = json['total_tokens'];
    elapsedTime = json['elapsed_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['prompt_tokens'] = this.promptTokens;
    data['completion_tokens'] = this.completionTokens;
    data['total_tokens'] = this.totalTokens;
    data['elapsed_time'] = this.elapsedTime;
    return data;
  }
}
