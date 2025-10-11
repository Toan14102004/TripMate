import 'package:flutter/material.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText ?? "Search packages", // Sử dụng hintText ở đây, nếu null thì dùng giá trị mặc định
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: context.isDarkMode ? Colors.grey.shade700 :Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Icon "tune" này có thể bạn sẽ muốn xử lý sự kiện nhấn vào nó sau này
        // Ví dụ: thêm một tham số `VoidCallback? onTunePressed`
        Container(
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.tune, color: Colors.white),
        ),
      ],
    );
  }
}