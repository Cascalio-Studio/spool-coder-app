/// Utility functions shared across the application
class SpoolUtils {
  /// Validate spool UID format
  static bool isValidUid(String uid) {
    if (uid.isEmpty) return false;
    // Add specific UID validation logic here
    return uid.length >= 8 && uid.isNotEmpty;
  }
  
  /// Format remaining length for display
  static String formatLength(double length) {
    if (length < 1) {
      return '${(length * 1000).toStringAsFixed(0)}mm';
    }
    return '${length.toStringAsFixed(1)}m';
  }
  
  /// Calculate and format usage percentage
  static String formatUsagePercentage(double used, double total) {
    if (total <= 0) return '0%';
    final percentage = (used / total) * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }
  
  /// Generate a simple checksum for data validation
  static int calculateChecksum(List<int> data) {
    int checksum = 0;
    for (int byte in data) {
      checksum ^= byte;
    }
    return checksum;
  }
}