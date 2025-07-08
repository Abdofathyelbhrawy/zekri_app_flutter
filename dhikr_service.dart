import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/dhikr.dart';

class DhikrService extends ChangeNotifier {
  static const String _storageKey = 'adhkar_data';
  final Random _random = Random();
  List<Dhikr> _allAdhkar = [];
  List<Dhikr> _completedAdhkar = [];

  List<Dhikr> get allAdhkar => _allAdhkar;
  List<Dhikr> get completedAdhkar => _completedAdhkar;

  Future<void> initializeAdhkar() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    if (savedData != null) {
      final List<dynamic> decodedData = json.decode(savedData);
      _allAdhkar = decodedData.map((item) => Dhikr.fromJson(item)).toList();
    } else {
      _allAdhkar = _getDefaultAdhkar();
      await saveAdhkar();
    }

    _updateCompletedAdhkar();
  }

  void _updateCompletedAdhkar() {
    _completedAdhkar = _allAdhkar.where((dhikr) => dhikr.isCompleted).toList();
  }

  Future<void> saveAdhkar() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _allAdhkar.map((d) => d.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Dhikr getRandomDhikr() {
    List<Dhikr> incompleteAdhkar =
        _allAdhkar.where((dhikr) => !dhikr.isCompleted).toList();

    if (incompleteAdhkar.isEmpty) {
      for (var dhikr in _allAdhkar) {
        dhikr.currentCount = 0;
        dhikr.isCompleted = false;
      }
      _completedAdhkar.clear();
      return _allAdhkar[_random.nextInt(_allAdhkar.length)];
    }

    return incompleteAdhkar[_random.nextInt(incompleteAdhkar.length)];
  }

  Future<void> incrementDhikr(Dhikr dhikr) async {
    final index = _allAdhkar.indexWhere((d) => d.text == dhikr.text);
    if (index != -1) {
      _allAdhkar[index].currentCount++;

      if (_allAdhkar[index].currentCount >= _allAdhkar[index].count) {
        _allAdhkar[index] = _allAdhkar[index].copyWith(
          isCompleted: true,
          lastCompleted: DateTime.now(),
        );
        _updateCompletedAdhkar();
      }

      await saveAdhkar();
      notifyListeners();
    }
  }

  Future<void> resetDhikr(Dhikr dhikr) async {
    final index = _allAdhkar.indexWhere((d) => d.text == dhikr.text);
    if (index != -1) {
      _allAdhkar[index].currentCount = 0;
      _allAdhkar[index].isCompleted = false;
      _updateCompletedAdhkar();
      await saveAdhkar();
      notifyListeners();
    }
  }

  List<Dhikr> _getDefaultAdhkar() {
    return [
      Dhikr(
        text: "سبحان الله وبحمده",
        count: 100,
        reference: "مسلم",
        category: "تسبيح",
        benefit: "حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ",
      ),
      Dhikr(
        text:
            "لا اله الا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير",
        count: 100,
        reference: "الترمذي",
        category: "توحيد",
        benefit:
            "كانت له عدل عشر رقاب، وكتبت له مائة حسنة، ومحيت عنه مائة سيئة",
      ),
      // ... يمكن إضافة المزيد من الأذكار هنا
    ];
  }

  List<Dhikr> getAdhkarByCategory(String category) {
    return _allAdhkar.where((dhikr) => dhikr.category == category).toList();
  }

  List<String> getCategories() {
    return _allAdhkar.map((dhikr) => dhikr.category).toSet().toList();
  }
}
