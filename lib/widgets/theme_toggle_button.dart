// lib/widgets/theme_toggle_button.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            themeProvider.toggleTheme();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).barBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CupertinoTheme.of(context)
                    .primaryColor
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              _getThemeIcon(themeProvider.themeMode),
              color: CupertinoTheme.of(context).primaryColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return CupertinoIcons.sun_max;
      case ThemeMode.dark:
        return CupertinoIcons.moon;
      case ThemeMode.system:
        return CupertinoIcons.device_desktop;
    }
  }
}

class ThemeSelectorSheet extends StatelessWidget {
  const ThemeSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoActionSheet(
          title: const Text('Chọn Theme'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                themeProvider.setLightMode();
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.sun_max,
                    color: themeProvider.themeMode == ThemeMode.light
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sáng',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.label,
                      fontWeight: themeProvider.themeMode == ThemeMode.light
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                themeProvider.setDarkMode();
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.moon,
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tối',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.label,
                      fontWeight: themeProvider.themeMode == ThemeMode.dark
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                themeProvider.setSystemMode();
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.device_desktop,
                    color: themeProvider.themeMode == ThemeMode.system
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hệ thống',
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.system
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.label,
                      fontWeight: themeProvider.themeMode == ThemeMode.system
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
        );
      },
    );
  }
}

class ThemeToggleButtonWithSheet extends StatelessWidget {
  const ThemeToggleButtonWithSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => const ThemeSelectorSheet(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).barBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CupertinoTheme.of(context)
                    .primaryColor
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              _getThemeIcon(themeProvider.themeMode),
              color: CupertinoTheme.of(context).primaryColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return CupertinoIcons.sun_max;
      case ThemeMode.dark:
        return CupertinoIcons.moon;
      case ThemeMode.system:
        return CupertinoIcons.device_desktop;
    }
  }
}
