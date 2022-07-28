import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/screens/add_story_page/add_story_page.dart';
import 'package:instaclone/screens/add_story_page/story_screen.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/add_sheet.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  Future<void> getFollowingPosts() async {
    context.read<HomePageProvider>().getUserStream();
    context.read<HomePageProvider>().getPostsStreamForMainPage();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, getFollowingPosts);
    super.initState();
  }
  Widget _buildInstaStories() {
    // Max item shown in list = 5
    final itemWidth = (MediaQuery.of(context).size.width - 12.0 * 5) / 5.5;

    return Column(
      children: [
        Container(
          height: itemWidth + 40,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: stories.length + 1,
            itemBuilder: (context, index) {
              return Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: index == 0
                          ? SelfStoryItemWidget(size: itemWidth)
                          : HomeStoryItemWidget(
                              onItemPress: () =>
                                  Get.to(StoryScreen(stories: stories)),
                              size: itemWidth,
                              story: stories[index - 1])));
            },
            separatorBuilder: (context, index) => SizedBox(width: 1.0),
          ),
        ),
        const Divider(
          color: Colors.black12,
          height: 1,
          thickness: 0.5,
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed =
        ProjectConstants.getPrimaryColor(context, true);

    var stream = context.watch<HomePageProvider>().postsStream;

    if (stream == null) {
      Future.delayed(Duration.zero, getFollowingPosts);
    }

    super.build(context);
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
          title: GestureDetector(
            onTap: () {
              if (context
                  .read<HomePageProvider>()
                  .mainPostsController
                  .hasClients) {
                context.read<HomePageProvider>().mainPostsController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            },
            child: SvgPicture.asset(
              "assets/icons/logo.svg",
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ProjectUtils.showBottomSheet(
                    context, (context) => const AddSheet());
              },
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                color: primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO : IMPLEMENT RECENTLY MENU
              },
              icon: SvgPicture.asset(
                'assets/icons/heart.svg',
                color: primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<HomePageProvider>().pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease);
              },
              icon: SvgPicture.asset(
                'assets/icons/messenger.svg',
                color: primaryColor,
              ),
            ),
          ],
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Container(
            //     height: MediaQuery.of(context).size.height * 0.10,
            //     width: MediaQuery.of(context).size.width,
            //     child: ListView.builder(
            //       itemCount: 1,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (context, index) => Column(
            //         children: [
            //           Stack(children: [
            //             CircleAvatar(
            //               radius: 30,
            //               backgroundImage:
            //                   AssetImage('assets/images/person2.png'),
            //             ),

            //             // Container(
            //             //   height: 60.h,
            //             //   width: 60.w,
            //             //   decoration: BoxDecoration(

            //             //     shape: BoxShape.circle,

            //             //       image: DecorationImage(
            //             //         image: AssetImage('assets/images/person2.png',)
            //             //       )

            //             //     // image: DecorationImage(
            //             //     //   image: AssetImage(storyList[index]),
            //             //     //   fit: BoxFit.cover,
            //             //   ),
            //             // ),
            //             Positioned(
            //                 bottom: -10,
            //                 left: 25,
            //                 child: IconButton(
            //                     onPressed: () {
            //                       // Navigator.push(
            //                       //   context,
            //                       //   MaterialPageRoute(
            //                       //       builder: (context) => Add_story()),
            //                       // );
            //                     },
            //                     icon: Icon(
            //                       Icons.add_circle_sharp,
            //                       color: Colors.blue,
            //                       size: 25,
            //                     )))
            //           ]),
            //           Text(
            //             ' your Story',
            //             style: TextStyle(
            //               fontSize: 12,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           )
            //         ],
            //       ),
            //     )),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width,
              child: (stream == null)
                  ? (context.watch<HomePageProvider>().userModel != null &&
                          context
                              .watch<HomePageProvider>()
                              .userModel!
                              .following
                              .isEmpty)
                      ? Container()
                      : Center(
                          child: ProjectUtils.progressIndicator(primaryColor),
                        )
                  : (context
                          .watch<HomePageProvider>()
                          .userModel!
                          .following
                          .isEmpty)
                      ? Container()
                      : StreamBuilder<List<List<PostModel>>>(
                          stream: stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<List<PostModel>>> list) {
                            if (list.hasError) {
                              return const Center(
                                child:
                                    Text('Something went wrong in home page'),
                              );
                            }

                            if (list.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: ProjectUtils.progressIndicator(
                                    primaryColor),
                              );
                            }

                            var data = list.data![0];

                            List<Widget> postWidgets = [];
                            for (var post in data) {
                              postWidgets.add(PostWidget(post: post));
                            }

                            return ListView(
                              controller: context
                                  .read<HomePageProvider>()
                                  .mainPostsController,
                              children: postWidgets,
                            );
                          },
                        ),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
