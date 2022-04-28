import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/screens/profile_page/profile_posts_general.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_page_provider.dart';
import '../../utils/project_constants.dart';

class ProfilePageGeneral extends StatefulWidget {
  final String userUUID;
  const ProfilePageGeneral({Key? key, required this.userUUID}) : super(key: key);

  @override
  State<ProfilePageGeneral> createState() => _ProfilePageGeneralState();
}

class _ProfilePageGeneralState extends State<ProfilePageGeneral> {
  Future<void> getUserData() async {
    bool response = await context.watch<ProfilePageProvider>().getUserData(widget.userUUID);
    // TODO : HANDLE RESPONSE
  }

  Future<void> getUserPosts() async {
    bool response = await context.read<ProfilePageProvider>().getUserPosts();
    // TODO : HANDLE RESPONSE
  }

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<ProfilePageProvider>().anotherUserData;

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    if (userData.isEmpty) {
      getUserData();
    }
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        elevation: 0,
        title: Text(
          userData['username'] ?? 'null',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/menu.svg',
              color: primaryColor,
            ),
          )
        ],
        centerTitle: false,
      ),
      body: userData.isEmpty
          ? Center(
              child: CircularProgressIndicator.adaptive(backgroundColor: ProjectConstants.getPrimaryColor(context, false)),
            )
          : DefaultTabController(
              length: 2,
              child: NestedScrollView(
                controller: context.read<ProfilePageProvider>().pageScrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([profileWidget(context, userData)]),
                    )
                  ];
                },
                body: Column(
                  children: [
                    TabBar(
                      indicatorColor: primaryColor,
                      tabs: [
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/grid.svg',
                            color: primaryColor,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/mentions.svg',
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ProfilePostsGeneral(userUUID: widget.userUUID),
                          Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget profileWidget(BuildContext context, Map<String, dynamic> userData) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    List<dynamic> following = userData['following'];
    List<dynamic> followers = userData['followers'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userData['profilePic'] == null || userData['profilePic'] == ''
                  ? const SizedBox(
                      width: 86.0,
                      height: 86.0,
                      child: CircleAvatar(foregroundImage: AssetImage('assets/images/default_profile_pic.png')),
                    )
                  : SizedBox(
                      width: 86.0,
                      height: 86.0,
                      child: CircleAvatar(foregroundImage: NetworkImage(userData['profilePic'])),
                    ),
              Column(
                children: [
                  Text(
                    context.watch<ProfilePageProvider>().posts.length.toString(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  Text('Posts', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  Text(followers.length.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text('Followers', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  Text(following.length.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text('Following', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            userData['name'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            userData['description'],
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO : IMPLEMENT FOLLOW USER
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(ProjectConstants.blueColor),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  child: const Text('Follow'),
                ),
                // child: OutlinedButton(
                //   onPressed: () {
                //     // TODO : IMPLEMENT FOLLOW
                //   },
                //   style: OutlinedButton.styleFrom(
                //     side: BorderSide(color: primaryColor.withOpacity(0.2)),
                //   ),
                //   child: Text(
                //     'Follow',
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontSize: 13.sp,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO : IMPLEMENT MESSAGE
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
