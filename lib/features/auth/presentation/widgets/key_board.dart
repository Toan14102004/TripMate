  // Widget _buildVirtualKeyboard() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       children: [
  //         // Row 1
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildKeyboardButton('1'),
  //             _buildKeyboardButton('2'),
  //             _buildKeyboardButton('3'),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         // Row 2
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildKeyboardButton('4'),
  //             _buildKeyboardButton('5'),
  //             _buildKeyboardButton('6'),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         // Row 3
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildKeyboardButton('7'),
  //             _buildKeyboardButton('8'),
  //             _buildKeyboardButton('9'),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         // Row 4
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _buildKeyboardButton('*'),
  //             _buildKeyboardButton('0'),
  //             _buildKeyboardButton('⌫', isBackspace: true),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildKeyboardButton(String text, {bool isBackspace = false}) {
  //   return GestureDetector(
  //     onTap: () => _handleKeyboardInput(text, isBackspace),
  //     child: Container(
  //       width: 72,
  //       height: 72,
  //       decoration: BoxDecoration(
  //         color: Colors.transparent,
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: isBackspace ? 20 : 24,
  //             fontWeight: FontWeight.w600,
  //             color: const Color(0xFF2D3748),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _handleKeyboardInput(String input, bool isBackspace) {
  //   int currentIndex = -1;
    
  //   // Find current focused field
  //   for (int i = 0; i < _focusNodes.length; i++) {
  //     if (_focusNodes[i].hasFocus) {
  //       currentIndex = i;
  //       break;
  //     }
  //   }
    
  //   // If no field is focused, find first empty field
  //   if (currentIndex == -1) {
  //     for (int i = 0; i < _controllers.length; i++) {
  //       if (_controllers[i].text.isEmpty) {
  //         currentIndex = i;
  //         _focusNodes[i].requestFocus();
  //         break;
  //       }
  //     }
  //   }
    
  //   if (currentIndex != -1) {
  //     if (isBackspace) {
  //       if (_controllers[currentIndex].text.isNotEmpty) {
  //         _controllers[currentIndex].clear();
  //       } else if (currentIndex > 0) {
  //         _controllers[currentIndex - 1].clear();
  //         _focusNodes[currentIndex - 1].requestFocus();
  //       }
  //     } else if (input != '*') {
  //       _controllers[currentIndex].text = input;
  //       _onCodeChanged(input, currentIndex);
  //     }
  //   }
  // }
