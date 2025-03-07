import 'package:flutter/material.dart';
import 'package:flutter_learning/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/providers/providers.dart';
import 'core/providers/theme_provider.dart';
import 'package:flame_spine/flame_spine.dart';
import 'core/services/services_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSpineFlutter();

  // Khởi tạo tất cả các dịch vụ
  await ServicesInitializer().initializeAllServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => AppProviders(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => MaterialApp.router(
            title: 'Story Nighty Night',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            // Configure localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('vi'), // Vietnamese
            ],
          ),
        ),
      ),
    );
  }
}
