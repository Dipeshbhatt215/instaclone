import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/screens/home_page/home_page.dart';
import 'package:instaclone/screens/profile_page/profile_page.dart';
import 'package:instaclone/screens/reels_page/reels_page.dart';
import 'package:instaclone/screens/search_page/search_page.dart';
import 'package:instaclone/screens/shop_page/shop_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

import 'login_page/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _homeScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _reelsScreen = GlobalKey<NavigatorState>();
  final _shopScreen = GlobalKey<NavigatorState>();
  final _profileScreen = GlobalKey<NavigatorState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await context.read<AuthenticationService>().signOut();
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            Navigator(
              key: _homeScreen,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => const HomePage(),
              ),
            ),
            Navigator(
              key: _searchScreen,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => const SearchPage(),
              ),
            ),
            Navigator(
              key: _reelsScreen,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => const ReelsPage(),
              ),
            ),
            Navigator(
              key: _shopScreen,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => const ShopPage(),
              ),
            ),
            Navigator(
              key: _profileScreen,
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => const ProfilePage(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ProjectConstants.getPrimaryColor(context, true),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/home_filled.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/search_filled.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/reels.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/reels_filled.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/shop.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/shop_filled.svg',
                color: ProjectConstants.getPrimaryColor(context, false),
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/profile_small.png'),
              activeIcon: Image.asset('assets/images/profile_small_filled.png'),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ProjectConstants.getPrimaryColor(context, false),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
