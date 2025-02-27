import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/post_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({Key? key}) : super(key: key);

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    var stream = context.watch<ProfilePageProvider>().userPostsStream;

    if (stream == null) {
      Future.delayed(Duration.zero,
          (() => context.read<ProfilePageProvider>().getUserPostsStream()));
    }

    return stream == null
        ? Center(
            child: ProjectUtils.progressIndicator(primaryColor),
          )
        : StreamBuilder<List<PostModel>>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<PostModel>> list) {
              if (list.hasError) {
                return const Center(
                  child: Text('Something went wrong in post'),
                );
              }

              if (list.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProjectUtils.progressIndicator(primaryColor),
                );
              }

              List<Widget> postWidgets = [];
              List<Widget> postImages = [];
              for (var post in list.data!) {
                PostWidget postWidget = PostWidget(post: post);
                postWidgets.add(postWidget);
                postImages.add(Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostPage(postWidget: postWidget)));
                    },
                    highlightColor: Colors.black.withOpacity(0.2),
                    focusColor: Colors.black.withOpacity(0.2),
                    hoverColor: Colors.black.withOpacity(0.2),
                    splashColor: Colors.black.withOpacity(0.2),
                    child: Ink.image(
                      image: CachedNetworkImageProvider(
                        post.pictures[0],
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
              }
              Future.delayed(Duration.zero, () {
                context
                    .read<ProfilePageProvider>()
                    .setUserPostsCount(postImages.length);
              });
              return GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: postImages,
              );
            },
          );
  }
}
