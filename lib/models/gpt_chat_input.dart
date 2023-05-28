class GptChatInput {
  String? model;
  double? temperature;
  List<Messages>? messages;

  GptChatInput({this.model, this.messages, this.temperature});

  GptChatInput.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    temperature = json['temperature'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['temperature'] = this.temperature;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? role;
  String? content;

  Messages({this.role, this.content});

  Messages.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['content'] = this.content;
    return data;
  }
}
