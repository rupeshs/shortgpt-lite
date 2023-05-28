class LlmInput {
  String? apiKey;
  String? model;
  String? prompt;
  double? temperature;
  bool? isLong;

  LlmInput(
      {this.apiKey, this.model, this.prompt, this.temperature, this.isLong});

  LlmInput.fromJson(Map<String, dynamic> json) {
    apiKey = json['apiKey'];
    model = json['model'];
    prompt = json['prompt'];
    temperature = json['temperature'];
    isLong = json['isLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiKey'] = this.apiKey;
    data['model'] = this.model;
    data['prompt'] = this.prompt;
    data['temperature'] = this.temperature;
    data['isLong'] = this.isLong;
    return data;
  }
}
