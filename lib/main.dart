import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/dashboard_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/plant_selection_screen.dart';

import 'utils/connectivity_utils.dart';
import 'services/sensor_service.dart';

/// 🔔 GLOBAL notification plugin
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔔 Initialize local notifications (ANDROID-SAFE)
Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await notificationsPlugin.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'plant_health_channel',
    'Plant Health Alerts',
    description: 'Alerts when plant health goes abnormal',
    importance: Importance.high,
  );

  final androidPlugin =
      notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidPlugin?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalNotifications();

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
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF81C784),
                brightness: Brightness.dark,
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

  /// ✅ REPORTS SCREEN ADDED HERE
  final List<Widget> _screens = const [
    DashboardScreen(),
    ReportsScreen(),
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
    

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) =>
            setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.insert_chart), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.camera), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

/// 🔔 Notification trigger (USED BY REPORTS)
Future<void> showPlantHealthAlert({
  required String plantName,
  required List<String> issues,
}) async {
  if (issues.isEmpty) return;

  await notificationsPlugin.show(
    0,
    '⚠ Plant Health Alert',
    '$plantName: ${issues.join(', ')}',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'plant_health_channel',
        'Plant Health Alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}
