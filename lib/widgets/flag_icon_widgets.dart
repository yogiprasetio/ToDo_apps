import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapps/common.dart';
import 'package:todoapps/provider/localizations_provider.dart';

import '../common/Localization.dart';

class FlagIconWidget extends StatefulWidget {
  const FlagIconWidget({super.key});

  @override
  State<FlagIconWidget> createState() => _FlagIconWidgetState();
}

class _FlagIconWidgetState extends State<FlagIconWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: const Icon(Icons.flag),
        items: AppLocalizations.supportedLocales.map((Locale locale) {
          final flag = Localization.getFlag(locale.languageCode);
          return DropdownMenuItem(
              child: Center(child: Text(flag)),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocalizationProvider>(context, listen: false);
                provider.setLocale(locale);
              });
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
