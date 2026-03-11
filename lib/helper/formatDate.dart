String formatDate(DateTime dateTime) {
  List<String> bulan = [
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

  String tanggal = dateTime.day.toString().padLeft(2, '0');
  String bulanString = bulan[dateTime.month - 1]; // Sesuaikan index bulan
  String tahun = dateTime.year.toString();
  String jam = dateTime.hour.toString().padLeft(2, '0');
  String menit = dateTime.minute.toString().padLeft(2, '0');

  return '$tanggal $bulanString $tahun, $jam.$menit';
}
