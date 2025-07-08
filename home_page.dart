import 'package:flutter/material.dart';
import 'dart:math';
import '../models/dhikr.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/completed_dhikr_list.dart';

class DhikrHomePage extends StatefulWidget {
  const DhikrHomePage({super.key});

  @override
  State<DhikrHomePage> createState() => _DhikrHomePageState();
}

class _DhikrHomePageState extends State<DhikrHomePage> {
  final List<Dhikr> allAdhkar = [
    Dhikr(text: "سبحان الله وبحمده", count: 100, reference: "متفق عليه"),
    Dhikr(
      text:
          "لا اله الا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير",
      count: 100,
      reference: "متفق عليه",
    ),
    Dhikr(
      text: "استغفر الله العظيم الذي لا اله الا هو الحي القيوم وأتوب إليه",
      count: 100,
      reference: "الترمذي",
    ),
    Dhikr(
      text: "اللهم صل وسلم وبارك على نبينا محمد",
      count: 100,
      reference: "مسلم",
    ),
    Dhikr(
      text: "حسبي الله لا اله الا هو عليه توكلت وهو رب العرش العظيم",
      count: 7,
      reference: "التوبة: 129",
    ),
    Dhikr(
      text: "اللهم إني أسألك الجنة وأعوذ بك من النار",
      count: 100,
      reference: "الترمذي",
    ),
    Dhikr(
      text: "اللهم اغفر لي وارحمني واهدني",
      count: 100,
      reference: "الترمذي",
    ),
    Dhikr(
      text:
          "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم",
      count: 3,
      reference: "الترمذي",
    ),
    Dhikr(
      text: "أعوذ بكلمات الله التامات من شر ما خلق",
      count: 3,
      reference: "مسلم",
    ),
    Dhikr(
      text:
          "سُبْحَانَ اللهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
      count: 3,
      reference: "الترمذي",
    ),
    Dhikr(
      text:
          "اللهم انت ربي لا اله الا انت خلقتني وانا عبدك وانا علي عهدك وعدك ما استطعت اعوذ بك من شر ما صنعت ابوء لك بنعمتك علي وابوء بذنبي فاغفر لي فانه لا يغفر الذنوب الا انت",
      count: 1,
      reference: "البخاري",
    ),
    Dhikr(
      text: "اللهم إني أسألك العفو والعافية في الدنيا والآخرة",
      count: 3,
      reference: "الترمذي",
    ),
    Dhikr(
      text:
          "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا",
      count: 3,
      reference: "الترمذي",
    ),
    Dhikr(
      text: "اللهم إني أعوذ بك من عذاب القبر",
      count: 3,
      reference: "الترمذي",
    ),
  ];

  late Dhikr currentDhikr;
  late String greeting;
  List<Dhikr> completedAdhkar = [];
  final Random random = Random();
  bool _isCounting = false;

  @override
  void initState() {
    super.initState();
    greeting = getGreeting();
    currentDhikr = getRandomDhikr();
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

  Dhikr getRandomDhikr() {
    List<Dhikr> incompleteAdhkar =
        allAdhkar.where((dhikr) => !dhikr.isCompleted).toList();
    if (incompleteAdhkar.isEmpty) {
      for (var dhikr in allAdhkar) {
        dhikr.currentCount = 0;
        dhikr.isCompleted = false;
      }
      completedAdhkar.clear();
      return allAdhkar[random.nextInt(allAdhkar.length)];
    }
    return incompleteAdhkar[random.nextInt(incompleteAdhkar.length)];
  }

  void incrementCounter() {
    setState(() {
      currentDhikr.currentCount++;
      if (currentDhikr.currentCount >= currentDhikr.count) {
        currentDhikr.isCompleted = true;
        completedAdhkar.add(currentDhikr);
        currentDhikr = getRandomDhikr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إكمال ذكر: ${currentDhikr.text}'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _startAutoCounting() {
    if (_isCounting) return;
    setState(() {
      _isCounting = true;
    });
    Future.doWhile(() async {
      if (!_isCounting) return false;
      incrementCounter();
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

  void resetCurrentDhikr() {
    setState(() {
      currentDhikr.currentCount = 0;
      currentDhikr.isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الأذكار'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentDhikr = getRandomDhikr();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFE3F6F5),
              Color(0xFFBEE9E8),
              Color(0xFF62B6CB),
              Color(0xFF1B4965),
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
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        greeting,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                              color: Colors.blueGrey[800],
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
                    onIncrement: incrementCounter,
                    onReset: resetCurrentDhikr,
                    isAutoCounting: _isCounting,
                    onToggleAutoCount:
                        _isCounting ? _stopAutoCounting : _startAutoCounting,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isCounting
                              ? _stopAutoCounting
                              : _startAutoCounting,
                          icon: Icon(
                            _isCounting ? Icons.stop : Icons.play_arrow,
                          ),
                          label: Text(
                            _isCounting ? 'إيقاف التسبيح' : 'تسبيح تلقائي',
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: _isCounting
                                ? Colors.red
                                : Colors.lightBlue[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: incrementCounter,
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'تسبيح',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: Colors.lightBlue[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: resetCurrentDhikr,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('إعادة تعيين العداد'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: BorderSide(color: Colors.lightBlue[400]!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CompletedDhikrList(
                    completedAdhkar: completedAdhkar,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
