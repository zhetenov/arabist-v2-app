import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
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
  String _dictionaryTitle = 'Іздеу';

  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());
  late final NavigatorObserver _dictObserver;

  _AppShellState() {
    _dictObserver = _DictionaryNavigatorObserver(_onDictionaryTopRouteChanged);
  }

  bool _isArabic(String text) {
    if (text.isEmpty) return false;
    final code = text.codeUnitAt(0);
    return code >= 0x0600 && code <= 0x06FF;
  }

  void _onDictionaryTopRouteChanged(Route<dynamic>? topRoute) {
    if (!mounted) return;
    if (_currentIndex != 0) return;

    String newTitle = 'Іздеу';

    if (topRoute != null) {
      if (topRoute.settings.name == 'details' &&
          topRoute.settings.arguments is WordModel) {
        final word = topRoute.settings.arguments as WordModel;
        newTitle = word.arabic?.isNotEmpty == true ? word.arabic! : 'Іздеу';
      }
    }

    if (newTitle != _dictionaryTitle) {
      setState(() => _dictionaryTitle = newTitle);
    }
  }

  void _onTap(int index) {
    if (index == _currentIndex) {
      final nav = _navigatorKeys[index].currentState;
      nav?.popUntil((route) => route.isFirst);

      if (index == 0) {
        // Вернулись на корень словаря
        setState(() => _dictionaryTitle = 'Іздеу');
      }
    } else {
      setState(() {
        _currentIndex = index;

        if (_currentIndex == 0) {
          final nav = _navigatorKeys[0].currentState;
          if (nav == null || !nav.canPop()) {
            _dictionaryTitle = 'Іздеу';
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F2B),
      appBar: _currentIndex == 0 ? _buildDictionaryAppBar() : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(
            0,
            const DictionaryPage(),
            observers: [_dictObserver],
          ),
          _buildNavigator(1, const FavoritesPage()),
          _buildNavigator(2, const GamePage()),
          _buildNavigator(3, const ProfilePage()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildDictionaryAppBar() {
    final isRoot = _dictionaryTitle == 'Іздеу';

    return AppBar(
     backgroundColor: const Color(0xFF0D0F2B),
      elevation: 0,
      centerTitle: true,
      title: Text(
        _dictionaryTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w500,
        ),
        textDirection: _isArabic(_dictionaryTitle)
            ? TextDirection.rtl
            : TextDirection.ltr,
      ),
      leadingWidth: 90,
      leading: isRoot
          ? GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://www.almaany.com/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: const Center(
                child: Text(
                  'المعاني',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                final nav = _navigatorKeys[0].currentState;
                if (nav == null) return;

                if (nav.canPop()) {
                  nav.pop();
                }
              },
            ),
    );
  }

  Widget _buildNavigator(
    int index,
    Widget child, {
    List<NavigatorObserver> observers = const [],
  }) {
    return Navigator(
      key: _navigatorKeys[index],
      observers: observers,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => child),
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
          colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
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

class _DictionaryNavigatorObserver extends NavigatorObserver {
  final void Function(Route<dynamic>?) onTopRouteChanged;

  _DictionaryNavigatorObserver(this.onTopRouteChanged);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onTopRouteChanged(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onTopRouteChanged(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    onTopRouteChanged(newRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onTopRouteChanged(previousRoute);
  }
}
