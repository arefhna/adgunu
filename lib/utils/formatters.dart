import 'package:intl/intl.dart';

class Fmt {
  static final NumberFormat _money = NumberFormat('#,##0.00', 'en_US');
  static final DateFormat _date = DateFormat('dd.MM.yyyy HH:mm', 'en_US');

  static String money(double v) => '${_money.format(v)} ₼';

  static String date(DateTime d) => _date.format(d);

  static String people(int n) {
    if (n == 1) return '1 nəfər';
    return '$n nəfər';
  }
}
