class GroqModel {
  List<Choices>? choices;

  GroqModel({this.choices});

  GroqModel.fromJson(Map<String, dynamic> json) {
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(new Choices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.choices != null) {
      data['choices'] = this.choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Choices {
  int? index;
  Message? message;
  Null? logprobs;
  String? finishReason;

  Choices({this.index, this.message, this.logprobs, this.finishReason});

  Choices.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    logprobs = json['logprobs'];
    finishReason = json['finish_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['logprobs'] = this.logprobs;
    data['finish_reason'] = this.finishReason;
    return data;
  }
}

class Message {
  String? role;
  String? content;

  Message({this.role, this.content});

  Message.fromJson(Map<String, dynamic> json) {
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
