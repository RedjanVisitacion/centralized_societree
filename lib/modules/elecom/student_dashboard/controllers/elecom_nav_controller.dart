import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ElecomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool resultsVisible = false.obs;
  final RxInt unreadCount = 0.obs;

  bool _bound = false;

  void bindTo(ValueNotifier<bool> resultsVN, ValueNotifier<int> unreadVN) {
    if (_bound) return;
    // Seed initial values
    resultsVisible.value = resultsVN.value;
    unreadCount.value = unreadVN.value;
    // Bridge updates from existing ValueNotifiers into GetX observables
    resultsVN.addListener(() {
      resultsVisible.value = resultsVN.value;
    });
    unreadVN.addListener(() {
      unreadCount.value = unreadVN.value;
    });
    _bound = true;
  }
}
