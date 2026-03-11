import '../models/Transaction.dart';

Map<String, List<Transaction>> groupTransactionsByDate(
  List<Transaction> transactions,
) {
  final Map<String, List<Transaction>> grouped = {};
  final now = DateTime.now();

  for (var transaction in transactions) {
    final date = transaction.transactionDate;
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.subtract(const Duration(days: 1)).day;

    final label =
        isToday
            ? "Hari ini"
            : isYesterday
            ? "Kemarin"
            : "${date.day} ${_monthName(date.month)} ${date.year}";

    grouped.putIfAbsent(label, () => []).add(transaction);
  }

  final sortedEntries =
      grouped.entries.toList()..sort((a, b) {
        final firstDate = a.value.first.transactionDate;
        final secondDate = b.value.first.transactionDate;
        return secondDate.compareTo(firstDate);
      });

  for (var entry in sortedEntries) {
    entry.value.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }

  return Map.fromEntries(sortedEntries);
}

String _monthName(int month) {
  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return months[month];
}
