import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/chat_model.dart';
import 'package:instaclone/models/user_model.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/screens/home_page/messenger_chat_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';


class MessengerPage extends StatefulWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> with AutomaticKeepAliveClientMixin<MessengerPage> {
  Future<void> getChatsStream() async {
    context.read<HomePageProvider>().getChatsStream();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, getChatsStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    if (context.read<HomePageProvider>().chatsStream == null) {
      getChatsStream();
    }

    var stream = context.watch<HomePageProvider>().chatsStream;

    super.build(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ProjectConstants.toolbarHeight,
        shape: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        elevation: 0,
        title: const Text('Messages'),
        centerTitle: false,
        leading: BackButton(
          color: primaryColor,
          onPressed: () {
            context
                .read<HomePageProvider>()
                .pageController
                .animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
          },
        ),
      ),
      body: (stream == null)
          ? Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: primaryColor,
              ),
            )
          : StreamBuilder<List<ChatModel>>(
              stream: stream,
              builder: (BuildContext context, AsyncSnapshot<List<ChatModel>> list) {
                if (list.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (list.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: primaryColor,
                    ),
                  );
                }

                var data = list.data;

                List<Widget> chatTileWidgets = [];
                for (var chat in data ?? <ChatModel>[]) {
                  chat.users ??= <UserModel>[];
                  String chatTileTitleText;
                  if (chat.users?.length == 1) {
                    chatTileTitleText = chat.users![0].name;
                  } else if (chat.users!.isEmpty) {
                    chatTileTitleText = 'Unnamed chat room';
                  } else {
                    List<String> users = [];
                    for (var element in chat.users!) {
                      users.add(element.name);
                    }
                    chatTileTitleText = users.join(', ');
                  }
                  String chatTileLastMessageText = chat.messages.isNotEmpty ? chat.messages.last.message : '';

                  chatTileWidgets.add(
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessengerChatPage(
                              documentId: chat.documentId,
                            ),
                          ),
                        );
                      },
                      splashColor: primaryColor.withOpacity(0.1),
                      highlightColor: primaryColor.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: (chat.users!.isNotEmpty && chat.users![0].profilePic != '')
                                  ? CachedNetworkImageProvider(chat.users![0].profilePic)
                                  : const AssetImage('assets/images/default_profile_pic.png') as ImageProvider,
                              radius: 26,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chatTileTitleText,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    chatTileLastMessageText,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(color: primaryColor.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView(
                  children: chatTileWidgets,
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
