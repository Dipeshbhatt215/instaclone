import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/profile_page/profile_page.dart';
import 'package:instaclone/screens/profile_page/profile_page_general.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/duration_timer_widget.dart';
import 'package:instaclone/widgets/post_comments_widget.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    //print(widget.post.userData);
    String profilePic = widget.post.userData?.profilePic as String;
    List<String> likes = [];

    for (var item in widget.post.likes) {
      likes.add(item.toString());
    }

    // WHAT KIND OF STUPID LANGUAGE THINKS AN EMPTY ARRAY
    // HAS THE LENGTH OF ONE WHEN DATA INSIDE IS FUCKING
    // EMPTY? I RAGED FOR 20 MINUTES WHILE FIGURING IT OUT
    if (likes.isNotEmpty && likes[0] == '') {
      likes.removeAt(0);
    }

    List<Widget> images = [];
    for (var picture in widget.post.pictures) {
      images.add(
        SizedBox(
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: picture,
            placeholder: (context, url) => ProjectUtils.progressIndicator(primaryColor),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: primaryColor.withOpacity(0.2),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProjectUtils.profilePictureAvatar(profilePic, 16),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userUUID == context.read<ProfilePageProvider>().loggedInUser?.uid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePageGeneral(userUUID: widget.post.userUUID),
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.post.userData?.username as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/icons/more.svg',
                color: primaryColor,
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            try {
              setState(() {
                if (widget.post.likes.contains(widget.post.userUUID)) {
                  widget.post.likes.remove(widget.post.userUUID);
                } else {
                  widget.post.likes.add(widget.post.userUUID);
                }
              });
              context.read<PostsProvider>().writePost(widget.post);
            } catch (e) {
              setState(() {
                if (widget.post.likes.contains(widget.post.userUUID)) {
                  widget.post.likes.remove(widget.post.userUUID);
                } else {
                  widget.post.likes.add(widget.post.userUUID);
                }
                ProjectUtils.showSnackBarMessage(context, 'An unexpected error occured: $e');
              });
            }
          },
          child: CarouselSlider(
              items: images,
              carouselController: _controller,
              options: CarouselOptions(
                  aspectRatio: 1,
                  viewportFraction: 1,
                  initialPage: 0,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  })),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Stack(
            children: [
              if (images.length > 1)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? Colors.blue
                                : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey).withOpacity(0.3),
                          ));
                    }).toList(),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          widget.post.likes.contains(widget.post.userUUID) ? 'assets/icons/heart_filled.svg' : 'assets/icons/heart.svg',
                          color: widget.post.likes.contains(widget.post.userUUID) ? ProjectConstants.redColor : primaryColor,
                        ),
                        onTap: () {
                          try {
                            setState(() {
                              if (widget.post.likes.contains(widget.post.userUUID)) {
                                widget.post.likes.remove(widget.post.userUUID);
                              } else {
                                widget.post.likes.add(widget.post.userUUID);
                              }
                            });
                            context.read<PostsProvider>().writePost(widget.post);
                          } catch (e) {
                            setState(() {
                              if (widget.post.likes.contains(widget.post.userUUID)) {
                                widget.post.likes.remove(widget.post.userUUID);
                              } else {
                                widget.post.likes.add(widget.post.userUUID);
                              }
                              ProjectUtils.showSnackBarMessage(context, 'An unexpected error occured: $e');
                            });
                          }
                        },
                      ),
                      SizedBox(width: 14.w),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostCommentsWidget(post: widget.post),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/comment.svg',
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        color: primaryColor,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/icons/bookmark.svg',
                    color: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${likes.length} likes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: widget.post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                      text: ' ${widget.post.description}',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              if (widget.post.comments.isNotEmpty)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostCommentsWidget(post: widget.post),
                    ),
                  ),
                  child: Text(
                    'See all comments',
                    style: TextStyle(
                      color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.6),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              SizedBox(height: 4.h),
              DurationTimerWidget(
                date: widget.post.timestamp.toDate(),
                textStyle: TextStyle(
                  color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.45),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}

