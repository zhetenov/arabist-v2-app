import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/dictionary_page.dart';
import 'package:arabist_v2_app/src/features/dictionary/presentation/pages/favorites_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  void _onTap(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, const DictionaryPage()),
          _buildNavigator(1, const FavoritesPage()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNavigator(int index, Widget page) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F2B),
        border: Border(top: BorderSide(color: Color(0x22FFFFFF), width: 1)),
      ),
      child: SafeArea(
        top: false,
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
            _navItem('assets/images/home.svg', 'Іздеу'),
            _navItem('assets/images/book.svg', 'Таңдаулылар'),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(String asset, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(asset,
          height: 22,
          width: 22,
          colorFilter:
              ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn)),
      activeIcon: SvgPicture.asset(asset,
          height: 22,
          width: 22,
          colorFilter:
              const ColorFilter.mode(Color(0xFFF5C851), BlendMode.srcIn)),
      label: label,
    );
  }
}
