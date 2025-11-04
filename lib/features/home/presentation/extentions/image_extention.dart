import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/src/extension/html_extension.dart';
import 'package:flutter/material.dart';

class SafeImageExtension extends HtmlExtension {
  const SafeImageExtension();

  @override
  Set<String> get supportedTags => {'img'};

  @override
  InlineSpan build(ExtensionContext context) {
    final src = context.attributes['src'];
    if (src == null || src.isEmpty) {
      // ✅ Nếu src null, trả icon thay vì crash
      return WidgetSpan(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      );
    }
    return WidgetSpan(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Image.network(
          src,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      ),
    );
  }
}
