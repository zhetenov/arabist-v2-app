import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/dictionary_page.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/favorites_page.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/game_page.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const DictionaryPage(),
    const FavoritesPage(),
    const GamePage(),
    const ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
       
    
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F2B),
          border: const Border(
            top: BorderSide(
              color: Color(0x22FFFFFF),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onTap,
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xFFF5C851),
              unselectedItemColor: Colors.grey[500],
              showUnselectedLabels: true,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              enableFeedback: false,
              iconSize: 22,
              items: [
                _navItem('assets/images/home.svg', 'Home'),
                _navItem('assets/images/book.svg', 'Vocabulary'),
                _navItem('assets/images/graduation.svg', 'Lessons'),
                _navItem('assets/images/user.svg', 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(String asset, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: SvgPicture.asset(
          asset,
          height: 22,
          width: 22,
          colorFilter: ColorFilter.mode(
            Colors.grey[500]!,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: SvgPicture.asset(
          asset,
          height: 22,
          width: 22,
          colorFilter: const ColorFilter.mode(
            Color(0xFFF5C851),
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}
