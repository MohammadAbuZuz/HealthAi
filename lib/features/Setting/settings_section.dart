import 'package:flutter/cupertino.dart';
import 'package:healthai/features/Setting/settings_theme.dart';

import '../../services/responsive.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final sectionPadding =
        padding ??
        EdgeInsets.only(
          bottom: Responsive.responsiveValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        );

    return Padding(
      padding: sectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SettingsTheme.titleStyle.copyWith(
              fontSize: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
          ),
          SizedBox(
            height: Responsive.responsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
