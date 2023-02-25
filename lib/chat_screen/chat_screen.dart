import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_reply_testing/model/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messageList = [];
  MessageModel? replyMessage;
  final focusNode = FocusNode();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("sfdgsdgsd===>>>>${messageList.length}");

    final isRelplying = replyMessage != null;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: SizedBox(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      itemCount: messageList.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onDoubleTap: () {
                              focusNode.requestFocus();
                              replyMessage = messageList[index];
                              setState(() {});
                            },
                            child: MessageBubble(
                              message: messageList[index].message,
                              replyMsg: messageList[index].replyMessage,
                              isRight: messageList[index].isRight,
                            ),
                          ))),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: Row(children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        if (isRelplying) buildReplyCard(),
                        TextFormField(
                            focusNode: focusNode,
                            controller: controller,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10),
                                  topLeft: isRelplying
                                      ? const Radius.circular(10)
                                      : const Radius.circular(10),
                                  topRight: isRelplying
                                      ? const Radius.circular(10)
                                      : const Radius.circular(10),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        print("sfgsd");
                        messageList.insert(
                            0,
                            MessageModel(
                              isRight: true,
                              message: controller.text,
                              replyMessage: replyMessage,
                            ));
                        controller.clear();
                        replyMessage = null;

                        setState(() {});
                      },
                      child: Center(
                        child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue.shade500,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReplyCard() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: Colors.green,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("jatin"),
                                GestureDetector(
                                    onTap: () {
                                      replyMessage = null;
                                      setState(() {});
                                      // focusNode.unfocus();
                                    },
                                    child: const Icon(Icons.cancel)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(replyMessage?.message ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageBubble extends StatelessWidget {
  final String? message;
  final bool? isRight;
  final MessageModel? replyMsg;

  const MessageBubble({super.key, this.message, this.isRight, this.replyMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 90, top: 15),
      child: Column(
        mainAxisAlignment:
            isRight == true ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isRight == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (replyMsg != null)
            ReplyMessageShownTile(
              replyMessage: replyMsg,
            ),
          Container(
            // margin: const EdgeInsets.only(left: 90, top: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isRight == true
                    ? Colors.green.shade200
                    : Colors.grey.shade200,
                borderRadius: isRight == true
                    ?  BorderRadius.only(
                        bottomLeft:const  Radius.circular(20),
                        bottomRight:const  Radius.circular(0),
                        topLeft:replyMsg != null
                            ? Radius.zero
                            :const  Radius.circular(20),
                        topRight: replyMsg != null
                            ? Radius.zero
                            :const Radius.circular(20))
                    : BorderRadius.only(
                        bottomLeft:const  Radius.circular(0),
                        bottomRight: const Radius.circular(20),
                        topLeft: replyMsg != null
                            ? Radius.zero
                            : const Radius.circular(20),
                        topRight: replyMsg != null
                            ? Radius.zero
                            : const Radius.circular(20))),
            child: Text(message ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}

class ReplyMessageShownTile extends StatelessWidget {
  final MessageModel? replyMessage;
  const ReplyMessageShownTile({super.key, this.replyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: Colors.green,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("jatin"),
                                // GestureDetector(
                                //     onTap: () {
                                //       replyMessage = null;
                                //       setState(() {});
                                //       // focusNode.unfocus();
                                //     },
                                //     child: const Icon(Icons.cancel)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(replyMessage?.message ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
