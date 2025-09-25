import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity((0.05 + (_hoverAnimation.value * 0.1)).clamp(0.0, 1.0)),
                      Colors.white.withOpacity((0.02 + (_hoverAnimation.value * 0.08)).clamp(0.0, 1.0)),
                    ],
                  ),
                  border: Border.all(
                    color: _isHovered 
                        ? widget.color.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Animated icon container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isHovered 
                            ? widget.color.withOpacity(0.8)
                            : widget.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Animated text
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: _isHovered ? widget.color.withOpacity(0.9) : Colors.white,
                          fontSize: _isHovered ? 17 : 16,
                          fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
                        ),
                        child: Text(widget.title),
                      ),
                    ),
                    
                    // Animated arrow
                    AnimatedRotation(
                      turns: _hoverAnimation.value * 0.25,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedScale(
                        scale: 1 + (_hoverAnimation.value * 0.3),
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _isHovered ? widget.color : Colors.white.withOpacity(0.5),
                          size: 18,
                        ),
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
