import 'package:flutter/material.dart';
import 'package:moedeiro/models/appTheme.dart';
import 'package:moedeiro/models/settings.dart';
import 'package:provider/provider.dart';

List<AppTheme> appThemes = [
  AppTheme(
    mode: ThemeMode.light,
    title: 'Light',
    image: 'lib/assets/icons/sun.png',
  ),
  AppTheme(
    mode: ThemeMode.dark,
    title: 'Dark',
    image: 'lib/assets/icons/moon.png',
  ),
  AppTheme(
    mode: ThemeMode.system,
    title: 'Auto',
    image: 'lib/assets/icons/auto.png',
  ),
];

class ThemeSwitcher extends StatelessWidget {
  final double _containerWidth = 450.0;
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (c, themeProvider, _) => SizedBox(
        height: (_containerWidth - (17 * 2) - (10 * 2)) / 3,
        child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 10),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          crossAxisCount: appThemes.length,
          children: List.generate(
            appThemes.length,
            (i) {
              bool _isSelectedTheme =
                  appThemes[i].mode == themeProvider.themeMode;
              return GestureDetector(
                onTap: _isSelectedTheme
                    ? null
                    : () =>
                        themeProvider.setSelectedThemeMode(appThemes[i].mode),
                child: AnimatedContainer(
                    height: 100,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _isSelectedTheme
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image(
                            image: AssetImage(appThemes[i].image),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 7),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    appThemes[i].title,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
