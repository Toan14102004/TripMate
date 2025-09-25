import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/widgets/drawer.dart';
import 'package:trip_mate/features/root/presentation/providers/page_bloc.dart';
import 'package:trip_mate/features/root/presentation/providers/page_state.dart';
import 'package:trip_mate/features/root/presentation/widgets/my_drawer.dart';
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: -10.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      builder: (context, state) {
        if (state is PageInitial) {
          return Scaffold(
            key: rootScaffoldKey,
            drawer: const MyDrawer(),
            backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
            body: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: IndexedStack(
                    key: ValueKey(state.selectedIndex),
                    index: state.selectedIndex,
                    children: context.read<PageCubit>().pages,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _buildAnimatedBottomNav(state),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAnimatedBottomNav(PageInitial state) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            isSelected: state.selectedIndex == 0,
            state: state,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.map_outlined,
            activeIcon: Icons.map,
            label: 'My Trip',
            isSelected: state.selectedIndex == 1,
            state: state,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.bookmark_outline,
            activeIcon: Icons.bookmark,
            label: 'Saved',
            isSelected: state.selectedIndex == 2,
            state: state,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: 'Settings',
            isSelected: state.selectedIndex == 3,
            state: state,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required PageState state,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _animationController.forward().then((_) {
            _animationController.reset();
          });
          
          context.read<PageCubit>().changePage(index: index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isSelected ? _scaleAnimation.value : 1.0,
                  child: Transform.translate(
                    offset: isSelected 
                        ? Offset(0, _slideAnimation.value) 
                        : Offset.zero,
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      color: isSelected ? Colors.blue : Colors.grey.shade600,
                      size: 26,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.7,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}