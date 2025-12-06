import 'package:flutter/material.dart';

class VotingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String label;
  final bool compact;
  final bool fullWidth;

  const VotingActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.compact = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = FilledButton.styleFrom(
      backgroundColor: isDark ? Colors.white : Colors.black,
      // Foreground controls icon + text default; we'll also enforce text color via Text widget style for clarity
      foregroundColor: isDark ? Colors.black : Colors.white,
      minimumSize: compact ? const Size(0, 40) : null,
      padding: compact ? const EdgeInsets.symmetric(horizontal: 16) : null,
      textStyle: TextStyle(
        color: isDark ? Colors.black87 : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );

    Widget btn;
    if (icon == null) {
      // Use plain FilledButton to keep the label perfectly centered
      btn = FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label, style: TextStyle(color: isDark ? Colors.black87 : Colors.white)),
      );
    } else {
      btn = FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: icon!,
        label: Text(label, style: TextStyle(color: isDark ? Colors.black87 : Colors.white)),
      );
    }
    if (fullWidth && !compact) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}
