import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';

Widget buildAnimatedTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  TextInputType? keyboardType,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(color: AppColors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ),
    ],
  );
}

Widget buildAnimatedDatePicker({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  required BuildContext context,
  String? Function(String?)? validator,
  Function(DateTime?)? onDateChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true, // Không cho phép nhập bằng bàn phím
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF667eea), // Màu chủ đạo của DatePicker
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              controller.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              if (onDateChanged != null) {
                onDateChanged(pickedDate);
              }
            }
          },
        ),
      ),
    ],
  );
}

Widget buildAnimatedButton({
  required VoidCallback? onPressed,
  required bool isLoading,
  required String title,
}) {
  return Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: const LinearGradient(colors: [AppColors.blue, AppColors.cyan]),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF667eea).withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
              : Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
    ),
  );
}
