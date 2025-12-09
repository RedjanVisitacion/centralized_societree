class PositionUtils {
  static int getPositionIndex(String pos) {
    String canon(String s) {
      var p = s.trim().toLowerCase();
      p = p.replaceAll('.', '');
      p = p.replaceAll(RegExp(r"\s+"), ' ');
      if (p == 'secretary' || p == 'gen sec' || p == 'general sec') return 'general secretary';
      if (p == 'pio' || p == 'public info officer' || p == 'public information officer') {
        return 'public information officer';
      }
      if (p.contains('representative')) {
        if (p.contains('bsit')) return 'bsit representative';
        if (p.contains('btled')) return 'btled representative';
        if (p.contains('bfpt')) return 'bfpt representative';
      }
      return p;
    }

    final order = [
      'President',
      'Vice President',
      'General Secretary',
      'Associate Secretary',
      'Treasurer',
      'Auditor',
      'Public Information Officer',
      'BSIT Representative',
      'BTLED Representative',
      'BFPT Representative',
    ];
    final key = canon(pos);
    final normalizedOrder = order.map(canon).toList();
    final i = normalizedOrder.indexOf(key);
    return i >= 0 ? i : 1000;
  }

  static List<String> sortPositions(List<String> positions) {
    final sorted = List<String>.from(positions);
    sorted.sort((a, b) => getPositionIndex(a).compareTo(getPositionIndex(b)));
    return sorted;
  }
}
