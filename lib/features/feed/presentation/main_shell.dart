import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../profile/presentation/profile_screen.dart';
import 'create_post_screen.dart';
import 'feed_screen.dart';

/// Pantalla principal con bottom navigation: Feed · Crear · Perfil.
/// El tab "Crear" abre CreatePostScreen como modal fullscreen y no
/// cambia el index seleccionado.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    FeedScreen(),
    ProfileScreen(),
  ];

  Future<void> _openCreatePost() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreatePostScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: _BelleBottomNav(
        index: _index,
        onChange: (i) => setState(() => _index = i),
        onCreate: _openCreatePost,
      ),
    );
  }
}

class _BelleBottomNav extends StatelessWidget {
  const _BelleBottomNav({
    required this.index,
    required this.onChange,
    required this.onCreate,
  });

  final int index;
  final ValueChanged<int> onChange;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BelleColors.ivory,
        border: Border(
          top: BorderSide(color: BelleColors.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                selected: index == 0,
                onTap: () => onChange(0),
              ),
              _CreateButton(onTap: onCreate),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                selected: index == 1,
                onTap: () => onChange(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Icon(
            selected ? activeIcon : icon,
            size: 26,
            color: selected
                ? BelleColors.charcoal
                : BelleColors.charcoalSubtle,
          ),
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: BelleColors.charcoal,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: BelleColors.ivory,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
