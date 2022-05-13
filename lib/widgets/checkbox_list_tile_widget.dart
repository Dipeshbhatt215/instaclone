import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/models/user_model.dart';
import 'package:instaclone/utils/project_constants.dart';

class CheckboxListTileWidget extends StatefulWidget {
  final UserModel userModel;
  final Function onPressedCallback;
  const CheckboxListTileWidget({super.key, required this.userModel, required this.onPressedCallback});

  @override
  State<CheckboxListTileWidget> createState() => _CheckboxListTileWidgetState();
}

class _CheckboxListTileWidgetState extends State<CheckboxListTileWidget> {
  bool checkState = false;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    return CheckboxListTile(
      title: Row(
        children: [
          CircleAvatar(
            foregroundImage: (widget.userModel.profilePic == '')
                ? const AssetImage('assets/images/default_profile_pic.png') as ImageProvider
                : CachedNetworkImageProvider(widget.userModel.profilePic),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel.username,
                  style: TextStyle(fontSize: 14.sp),
                ),
                Text(
                  widget.userModel.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: primaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      checkboxShape: const CircleBorder(),
      value: checkState,
      activeColor: ProjectConstants.blueColor,
      onChanged: (val) {
        setState(() {
          checkState = val ?? false;
        });
        widget.onPressedCallback(widget.userModel, val);
      },
    );
  }
}
