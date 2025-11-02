import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart'; // Giả định helper này tồn tại

class AdvancedTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onToggleEdit;
  final VoidCallback onSelectDate;
  final Function(String) onTextChange;
  final int delay;

  const AdvancedTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
    required this.onToggleEdit,
    required this.onSelectDate,
    required this.onTextChange,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    bool isDobField = label == 'Date of Birth';
    bool isDarkMode = context.isDarkMode;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  // Sử dụng callback onToggleEdit
                  onTap: onToggleEdit,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isEditing
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isEditing ? Icons.check : Icons.edit,
                      size: 16,
                      color: isEditing ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              // ✅ Logic 1: Gradient chỉ áp dụng khi chỉnh sửa VÀ KHÔNG ở Dark Mode
              gradient: isEditing && !isDarkMode
                  ? LinearGradient(
                      colors: [Colors.orange.shade50, Colors.blue.shade50],
                    )
                  : null,

              // ✅ Logic 2: Màu nền
              color: isEditing
                  ? (isDarkMode
                      ? const Color(0xFF2E2E3E) // Dark Mode, Editing: giữ màu đậm
                      : null) // Light Mode, Editing: gradient xử lý
                  : (isDarkMode
                      ? const Color(0xFF2E2E3E) // Dark Mode, Not Editing
                      : Colors.white), // Light Mode, Not Editing

              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEditing
                    ? Colors.blue.shade300
                    : (isDarkMode
                        ? Colors.grey[700]!
                        : Colors.grey.shade200),
                width: isEditing ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isEditing ? 0.1 : 0.05),
                  blurRadius: isEditing ? 15 : 8,
                  offset: Offset(0, isEditing ? 5 : 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: isEditing
                        ? LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.blue.shade400,
                            ],
                          )
                        : null,
                    color: isEditing ? null : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isEditing
                        ? Colors.white
                        : (isDarkMode ? Colors.grey[400] : Colors.grey.shade600),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isDobField
                      ? isEditing
                          ? GestureDetector(
                              // Sử dụng callback onSelectDate
                              onTap: onSelectDate,
                              child: Text(
                                controller.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? const Color.fromARGB(
                                          255, 162, 159, 175)
                                      : Colors.black87,
                                ),
                              ),
                            )
                          : Text(
                              controller.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode
                                    ? const Color.fromARGB(
                                        255, 162, 159, 175)
                                    : Colors.black87,
                              ),
                            )
                      : isEditing
                          ? TextField(
                              controller: controller,
                              onChanged: (value) => onTextChange(value),
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 162, 159, 175)
                                    : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            )
                          : Text(
                              controller.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
