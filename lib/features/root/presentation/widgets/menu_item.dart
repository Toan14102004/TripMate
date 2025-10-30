import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';

class FloatingMenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Duration delay;

  const FloatingMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<FloatingMenuItem> createState() => _FloatingMenuItemState();
}

class _FloatingMenuItemState extends State<FloatingMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onHover: (hovering) {
            setState(() {
              _isHovered = hovering;
            });
            if (hovering) {
              _hoverController.forward();
            } else {
              _hoverController.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _isHovered 
                      ? widget.color.withOpacity(0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: _isHovered 
                        ? widget.color.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(
                          _isHovered ? 0.2 : 0.1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 22,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: _isHovered ? 16 : 15,
                          fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                        ),
                        child: Text(widget.title),
                      ),
                    ),
                    
                    AnimatedRotation(
                      turns: _hoverAnimation.value * 0.25,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _isHovered 
                            ? widget.color 
                            : (isDark ? Colors.white54 : Colors.grey),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
