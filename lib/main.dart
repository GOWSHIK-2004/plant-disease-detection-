import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/dashboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/plant_selection_screen.dart';

import 'utils/connectivity_utils.dart';
import 'services/sensor_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  final chatProvider = ChatProvider();

  userProvider.onLogin = () async {
    await chatProvider.loadChatHistory();
  };
  userProvider.onLogout = () async {
    await chatProvider.clearChatHistory();
  };

  await userProvider.checkLoginStatus();
  await chatProvider.loadChatHistory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: chatProvider),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<SensorService>(
      create: (_) => SensorService()..startAutoRefresh(),
      dispose: (_, service) => service.dispose(),
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, _) {
          if (!languageProvider.isInitialized) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            title: 'Botaniq',
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,

            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2E7D32),
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),

              appBarTheme: AppBarTheme(
                centerTitle: true,
                backgroundColor: const Color(0xFFF5F5F5),
                elevation: 0,
                toolbarHeight: 70,
                titleTextStyle: GoogleFonts.poppins(
                  color: const Color(0xFF2E7D32),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
              ),

              // ✅ CORRECT
              cardTheme: const CardTheme(
                elevation: 2,
                shadowColor: Color(0x332E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF81C784),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),

              // ✅ CORRECT
              cardTheme: const CardTheme(
                color: Color(0xFF1E1E1E),
                elevation: 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),

            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            home: Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return userProvider.isLoggedIn
                    ? userProvider.hasSelectedPlants
                        ? const MainScreen()
                        : const PlantSelectionScreen()
                    : const AuthScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hasInternet = true;
  Timer? _connectivityTimer;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ChatScreen(),
    ScanScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivityTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => _checkConnection());
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    final hasInternet =
        await ConnectivityUtils.hasRealInternetConnection().catchError((_) {
      return false;
    });
    if (mounted) {
      setState(() => _hasInternet = hasInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, UserProvider>(
      builder: (context, languageProvider, userProvider, _) {
        if (!_hasInternet) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_wifi_off,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(languageProvider.getText('no_internet')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _checkConnection,
                    child: Text(languageProvider.getText('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) =>
                setState(() => _selectedIndex = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard),
                label: languageProvider.getText('dashboard'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.chat),
                label: languageProvider.getText('chat'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.camera),
                label: languageProvider.getText('scan'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings),
                label: languageProvider.getText('settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}
