import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/dhikr.dart';
import 'theme/app_theme.dart';
import 'services/dhikr_service.dart';
import 'widgets/dhikr_card.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => DhikrService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الأذكار',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DhikrHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DhikrHomePage extends StatefulWidget {
  const DhikrHomePage({super.key});

  @override
  State<DhikrHomePage> createState() => _DhikrHomePageState();
}

class _DhikrHomePageState extends State<DhikrHomePage> {
  late Dhikr currentDhikr;
  late String greeting;
  bool _isCounting = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    greeting = getGreeting();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final dhikrService = Provider.of<DhikrService>(context, listen: false);
    await dhikrService.initializeAdhkar();
    setState(() {
      currentDhikr = dhikrService.getRandomDhikr();
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير 🌞';
    } else if (hour >= 12 && hour < 18) {
      return 'مساء الخير 🌇';
    } else {
      return 'مساء الخير 🌙';
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _startAutoCounting() {
    if (_isCounting) return;

    setState(() {
      _isCounting = true;
    });

    Future.doWhile(() async {
      if (!_isCounting) return false;

      await _incrementCounter();
      await Future.delayed(const Duration(milliseconds: 300));
      return _isCounting && currentDhikr.currentCount < currentDhikr.count;
    }).whenComplete(() {
      setState(() {
        _isCounting = false;
      });
    });
  }

  void _stopAutoCounting() {
    setState(() {
      _isCounting = false;
    });
  }

  Future<void> _incrementCounter() async {
    final dhikrService = Provider.of<DhikrService>(context, listen: false);
    await dhikrService.incrementDhikr(currentDhikr);

    if (currentDhikr.currentCount >= currentDhikr.count) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إكمال ذكر: ${currentDhikr.text}'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        currentDhikr = dhikrService.getRandomDhikr();
      });
    }
  }

  Future<void> _resetCurrentDhikr() async {
    final dhikrService = Provider.of<DhikrService>(context, listen: false);
    await dhikrService.resetDhikr(currentDhikr);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final dhikrService = Provider.of<DhikrService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الأذكار'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentDhikr = dhikrService.getRandomDhikr();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        greeting,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: isSmallScreen ? 18 : 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DhikrCard(
                    dhikr: currentDhikr,
                    isSmallScreen: isSmallScreen,
                    onIncrement: _incrementCounter,
                    onReset: _resetCurrentDhikr,
                    isAutoCounting: _isCounting,
                    onToggleAutoCount:
                        _isCounting ? _stopAutoCounting : _startAutoCounting,
                  ),
                  const SizedBox(height: 16),
                  if (dhikrService.completedAdhkar.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'الأذكار المكتملة',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: isSmallScreen ? 18 : 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...dhikrService.completedAdhkar.map(
                      (dhikr) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          title: Text(
                            dhikr.text,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${dhikr.count} مرة - ${dhikr.reference}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
