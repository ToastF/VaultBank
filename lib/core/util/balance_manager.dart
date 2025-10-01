class BalanceManager {
  static int balance = 400247; // Initial balance in rupiah (without Rp)

  static void deductBalance(int amount) {
    balance -= amount;
  }

  static String getFormattedBalance() {
    return 'Rp${balance.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
