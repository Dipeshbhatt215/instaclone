import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/comment_widget.dart';
import 'package:provider/provider.dart';

class PostCommentsWidget extends StatefulWidget {
  final PostModel post;
  const PostCommentsWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    getUsersForComments();
  }

  Future<void> getUsersForComments() async {
    if (widget.post.comments.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await context.read<PostsProvider>().getUsersForComments(widget.post);
      for (var element in usersSnapshot.docs) {
        users.add(element.data());
      }
      setState(() {});
    }
  }

  Map<String, dynamic> getUserFromUsers(String userUUID) {
    for (var user in users) {
      if (user['userUUID'] == userUUID) {
        return user;
      }
    }
    throw 'user not found error: given userUUID $userUUID doesn\'t match in the users. users: ${users.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.comments.isNotEmpty && users.isEmpty) {
      getUsersForComments();
    }

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    List<Widget> comments = [];

    for (var comment in widget.post.comments) {
      if (users.isNotEmpty) {
        try {
          comments.add(
            CommentWidget(
              commentModel: comment,
              userModel: getUserFromUsers(comment.userUUID),
            ),
          );
        } catch (e) {
          // TODO : URGENT
          // TODO : HANDLE UNEXPECTED USER NOT FOUND ERROR
          print('unexpected error: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        automaticallyImplyLeading: true,
        title: const Text('Comments'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO : IMPLEMENT SHARE POST SCREEN
            },
            icon: SvgPicture.asset(
              'assets/icons/share.svg',
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  foregroundImage: (widget.post.userData['profilePic'] != null && widget.post.userData['profilePic'] != '')
                      ? NetworkImage(widget.post.userData['profilePic'])
                      : const AssetImage('assets/images/default_profile_pic.png') as ImageProvider,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: primaryColor,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO : IMPLEMENT GO THE PROFILE
                                  },
                                  child: Text(
                                    widget.post.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.post.description}',
                              ),
                            ],
                          ),
                        ),
                        Text(
                          ProjectUtils.timestampToString(widget.post.timestamp, Timestamp.now()),
                          style: TextStyle(
                            color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.3),
            width: double.infinity,
            height: 0.5,
          ),
          if (comments.isNotEmpty)
            users.isEmpty
                ? CircularProgressIndicator.adaptive(
                    backgroundColor: ProjectConstants.getPrimaryColor(context, false),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: comments,
                    ),
                  ),
        ],
      ),
    );
  }
}
