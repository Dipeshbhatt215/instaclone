import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/models/comment_model.dart';
import 'package:instaclone/screens/profile_page/profile_page_general.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/duration_timer_widget.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel commentModel;
  final Map<String, dynamic>? userModel;
  const CommentWidget({Key? key, required this.commentModel, required this.userModel, required String message}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectUtils.profilePictureAvatar(
            (widget.userModel == null || widget.userModel!['profilePic'] == null) ? '' : widget.userModel!['profilePic'],
            null,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => ProfilePageGeneral(userUUID: widget.userModel!['userUUID'])),
                                ),
                              );
                            },
                            child: Text(
                              widget.userModel!['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.commentModel.comment}',
                        ),
                      ],
                    ),
                  ),
                  DurationTimerWidget(
                    date: widget.commentModel.timestamp.toDate(),
                    textStyle: TextStyle(
                      color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.45),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
