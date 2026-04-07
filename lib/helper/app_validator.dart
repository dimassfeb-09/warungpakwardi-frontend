// lib/helper/app_validator.dart

class AppValidator {
  // ─── Product Validation ─────────────────────────────────

  /// Nama produk: tidak boleh kosong, minimal 2 karakter, maks 100 karakter.
  static String? validateProductName(String value) {
    if (value.trim().isEmpty) return 'Nama produk tidak boleh kosong';
    if (value.trim().length < 2) return 'Nama produk minimal 2 karakter';
    if (value.trim().length > 100) return 'Nama produk maksimal 100 karakter';
    return null;
  }

  /// Harga Jual: wajib diisi, harus > 0.
  static String? validatePrice(double value) {
    if (value <= 0) return 'Harga jual harus lebih dari 0';
    if (value > 999_999_999) return 'Harga terlalu besar';
    return null;
  }

  /// Harga Modal (Purchase Price): wajib diisi, harus >= 0.
  static String? validatePurchasePrice(double value) {
    if (value < 0) return 'Harga modal tidak boleh negatif';
    if (value > 999_999_999) return 'Harga terlalu besar';
    return null;
  }

  /// Jumlah per satuan: wajib diisi, harus >= 1.
  static String? validateAmountPerUnit(int value) {
    if (value < 1) return 'Jumlah persatuan minimal 1';
    if (value > 10_000) return 'Jumlah persatuan terlalu besar';
    return null;
  }

  /// Satuan: tidak boleh kosong, maks 20 karakter.
  static String? validateUnit(String value) {
    if (value.trim().isEmpty) return 'Satuan tidak boleh kosong';
    if (value.trim().length > 20) return 'Satuan maksimal 20 karakter';
    return null;
  }

  /// Stok: tidak boleh negatif.
  static String? validateStock(num value) {
    if (value < 0) return 'Stok tidak boleh negatif';
    if (value > 999_999) return 'Stok terlalu besar';
    return null;
  }

  // ─── Transaction Validation ─────────────────────────────

  /// Validasi cart: tidak boleh kosong.
  static String? validateCartNotEmpty(int itemCount) {
    if (itemCount == 0) return 'Pilih minimal 1 produk sebelum menyimpan';
    return null;
  }

  /// Validasi kuantitas tidak melebihi stok.
  static String? validateQuantityVsStock(num quantity, num stock) {
    if (quantity <= 0) return 'Jumlah harus lebih dari 0';
    if (quantity > stock) {
      return 'Kuantitas melebihi stok ($stock)';
    }
    return null;
  }

  // ─── Date Range Validation ─────────────────────────────

  /// Validasi rentang tanggal: start <= end dan tidak di masa depan.
  static String? validateDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Pilih rentang tanggal';
    if (end.isBefore(start)) return 'Tanggal akhir tidak boleh sebelum tanggal awal';
    if (end.isAfter(DateTime.now().add(const Duration(days: 1)))) {
       return 'Rentang tanggal tidak boleh di masa depan';
    }
    return null;
  }

  // ─── Generic Number Validation ─────────────────────────

  /// Validasi angka dalam rentang tertentu.
  static String? validateNumberRange(num value, {num min = 0, num max = double.infinity, String? fieldName}) {
    final name = fieldName ?? 'Nilai';
    if (value < min) return '$name minimal adalah $min';
    if (value > max) return '$name maksimal adalah $max';
    return null;
  }

  // ─── Helper: All Product Fields ────────────────────────

  /// Validasi semua field produk sekaligus (untuk final check saat submit).
  /// Mengembalikan Map dengan fieldName sebagai key dan pesan error sebagai value.
  static Map<String, String?> validateProductForm({
    required String name,
    required double price,
    required double purchasePrice,
    required int amountPerUnit,
    required String unit,
    required num stock,
  }) {
    return {
      'name': validateProductName(name),
      'price': validatePrice(price),
      'purchasePrice': validatePurchasePrice(purchasePrice),
      'amountPerUnit': validateAmountPerUnit(amountPerUnit),
      'unit': validateUnit(unit),
      'stock': validateStock(stock),
    };
  }

  /// Mengembalikan `true` jika semua error adalah null (valid).
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((e) => e == null);
  }
}
