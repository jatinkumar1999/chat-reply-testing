class MessageModel {
  String? message;
  bool? isRight=false;
  MessageModel ?replyMessage;

  MessageModel({this.message, this.isRight,this.replyMessage});
}
