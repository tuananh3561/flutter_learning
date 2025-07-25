import 'package:flutter/material.dart';
import 'package:flutter_learning/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/providers/providers.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'package:flame_spine/flame_spine.dart';
import 'core/services/services_initializer.dart';
import 'data/datasources/local/asset_local_datasource.dart';
import 'data/repositories/asset_repository_impl.dart';
import 'domain/repositories/asset_repository.dart';
import 'package:flutter/services.dart';
import 'core/network/media_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSpineFlutter();

  // Khởi tạo các services và repositories
  final mediaApiService = MediaApiService(
    token:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MzgyMTU0LCJmdWxsbmFtZSI6IktUX1R1YW5fQW5oIiwiZW1haWwiOiJsZWNvbmd0dWFuYW5oMzU2QGdtYWlsLmNvbSIsInBhc3N3b3JkIjoiMjVkNTVhZDI4M2FhNDAwYWY0NjRjNzZkNzEzYzA3YWQiLCJhZ2VudF9pZCI6NDA0NzIwLCJpbWFnZSI6IiIsImdyb3VwX2lkX3Blcm1pc3Npb25fZ2V0X25ld19vcmRlciI6NDgsImdldF9vcmRlciI6IjEiLCJtYXhfY2FsbCI6MCwidGltZV9kdXJpbmdfc3lzdGVtIjo2MDAwLCJjYXJlc29mdF9hZ2VudF9pZCI6MjE4NzUsInJvbGVfaWRzIjp7IjEiOnsicm9sZV9pZCI6MX0sIjE1Ijp7InJvbGVfaWQiOjE1fSwiMTYiOnsicm9sZV9pZCI6MTZ9LCIxOCI6eyJyb2xlX2lkIjoxOH0sIjIzIjp7InJvbGVfaWQiOjIzfSwiMjUiOnsicm9sZV9pZCI6MjV9LCIyNyI6eyJyb2xlX2lkIjoyN30sIjMxIjp7InJvbGVfaWQiOjMxfSwiMzciOnsicm9sZV9pZCI6Mzd9LCI0MyI6eyJyb2xlX2lkIjo0M30sIjUyIjp7InJvbGVfaWQiOjUyfSwiNTYiOnsicm9sZV9pZCI6NTZ9LCI1NyI6eyJyb2xlX2lkIjo1N30sIjU4Ijp7InJvbGVfaWQiOjU4fSwiNTkiOnsicm9sZV9pZCI6NTl9LCI2MCI6eyJyb2xlX2lkIjo2MH0sIjYxIjp7InJvbGVfaWQiOjYxfSwiNjIiOnsicm9sZV9pZCI6NjJ9LCI2MyI6eyJyb2xlX2lkIjo2M30sIjY0Ijp7InJvbGVfaWQiOjY0fSwiNzAiOnsicm9sZV9pZCI6NzB9LCI3MSI6eyJyb2xlX2lkIjo3MX0sIjcyIjp7InJvbGVfaWQiOjcyfSwiNzciOnsicm9sZV9pZCI6Nzd9LCI3OCI6eyJyb2xlX2lkIjo3OH0sIjgyIjp7InJvbGVfaWQiOjgyfSwiMTAzIjp7InJvbGVfaWQiOjEwM30sIjEwNCI6eyJyb2xlX2lkIjoxMDR9LCIxMDUiOnsicm9sZV9pZCI6MTA1fSwiMTM2Ijp7InJvbGVfaWQiOjEzNn19LCJyb2xlX25hbWUiOnsiTUFOQUdFIjoiTUFOQUdFIiwiU0FMRVMiOiJTQUxFUyIsIk1BUktFVElORyI6Ik1BUktFVElORyIsIkFGRklMSUFURSI6IkFGRklMSUFURSIsIk9QRVJBVE9SIjoiT1BFUkFUT1IiLCJPUEVSQVRPUl9NQU5BR0UiOiJPUEVSQVRPUl9NQU5BR0UiLCJDVVNUT01FUl9DQVJFX01BTkFHRSI6IkNVU1RPTUVSX0NBUkVfTUFOQUdFIiwiTUFSS0VUSU5HX01BTkFHRSI6Ik1BUktFVElOR19NQU5BR0UiLCJTQUxFX1BUX01BTkFHRSI6IlNBTEVfUFRfTUFOQUdFIiwiT1JERVJfRFVQTElDQVRFIjoiT1JERVJfRFVQTElDQVRFIiwiSFIiOiJIUiIsIk5cdTFlZDlpIER1bmciOiJOXHUxZWQ5aSBEdW5nIiwiTEVBRF9DT05URU5UX01KIjoiTEVBRF9DT05URU5UX01KIiwiTEVBRF9DT05URU5UX01TIjoiTEVBRF9DT05URU5UX01TIiwiTEVBRF9DT05URU5UX01NIjoiTEVBRF9DT05URU5UX01NIiwiTEVBRF9DT05URU5UX1ZNIjoiTEVBRF9DT05URU5UX1ZNIiwiTUVNQkVSX01KIjoiTUVNQkVSX01KIiwiTUVNQkVSX01TIjoiTUVNQkVSX01TIiwiTUVNQkVSX01NIjoiTUVNQkVSX01NIiwiTUVNQkVSX1ZNIjoiTUVNQkVSX1ZNIiwiREhMIjoiREhMIiwiREhMIFRIQUkiOiJESEwgVEhBSSIsIkRITF9QUklOVCI6IkRITF9QUklOVCIsIkJPWE1FX1RIQUkiOiJCT1hNRV9USEFJIiwiQk9YTUVfUFJJTlQiOiJCT1hNRV9QUklOVCIsIkRFVl9BUFAiOiJERVZfQVBQIiwiTUFOQUdFX09LUlMiOiJNQU5BR0VfT0tSUyIsIkxFQURFUl9URUFNIjoiTEVBREVSX1RFQU0iLCJTVEFGRiI6IlNUQUZGIiwiQ0xFVkVSVEFQIjoiQ0xFVkVSVEFQIn0sImNvdW50cnkiOnsiMSI6eyJjb3VudHJ5X2NvZGUiOjF9LCI2MCI6eyJjb3VudHJ5X2NvZGUiOjYwfSwiNjIiOnsiY291bnRyeV9jb2RlIjo2Mn0sIjYzIjp7ImNvdW50cnlfY29kZSI6NjN9LCI2NiI6eyJjb3VudHJ5X2NvZGUiOjY2fSwiODQiOnsiY291bnRyeV9jb2RlIjo4NH0sIjg4MCI6eyJjb3VudHJ5X2NvZGUiOjg4MH19LCJpc19jdXN0b21lcl9jYXJlX3MxIjpmYWxzZSwiaXNfY3VzdG9tZXJfY2FyZV9zMiI6ZmFsc2UsImlzX2N1c3RvbWVyX2NhcmVfbGVhZCI6ZmFsc2UsImlzX2N1c3RvbWVyX2NhcmVfbWFuYWdlIjp0cnVlLCJpc19zYWxlIjp0cnVlLCJpc19ta3QiOnRydWUsImlzX3NhbGVfYWRtaW4iOmZhbHNlLCJpc19vcGVyYXRlIjp0cnVlLCJpc19vcGVyYXRlX3ByaW50IjpmYWxzZSwiaXNfb3BlcmF0ZV9hZG1pbiI6dHJ1ZSwiaXNfZXhwb3J0X2RhdGEiOmZhbHNlLCJleHAiOjE3NTA0OTk1NTJ9.w1cqczBzz_KU_Ba8KAQfMaT5YpaUeXrhUaAEHoBN6sk', // Thay thế bằng token thực tế
    bucket: 'monkeymedia2020',
  );

  final assetLocalDataSource = AssetLocalDataSource(mediaApiService);
  await assetLocalDataSource.init();

  final assetRepository = AssetRepositoryImpl(assetLocalDataSource);
  await assetRepository.init();

  // Thiết lập orientation mặc định
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);

  // Khởi tạo tất cả các dịch vụ
  await ServicesInitializer().initializeAllServices();

  // Chạy app với MultiProvider để cung cấp repository
  runApp(
    MultiProvider(
      providers: [
        Provider<MediaApiService>.value(value: mediaApiService),
        Provider<AssetRepository>.value(value: assetRepository),
      ],
      child: const MyApp(),
    ),
  );
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
        child: Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) =>
              MaterialApp.router(
            title: 'Story Nighty Night',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageProvider.currentLocale,
            routerConfig: AppRouter.router,
            // Configure localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: languageProvider.supportedLocales,
          ),
        ),
      ),
    );
  }
}
