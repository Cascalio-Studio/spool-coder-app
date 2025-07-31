import '../entities/spool.dart';
import '../value_objects/filament_length.dart';

/// Domain service for calculating usage statistics and predictions
/// Part of the Domain Layer: encapsulates complex calculation logic
abstract class SpoolCalculationService {
  /// Calculate estimated print time remaining
  EstimatedPrintTime calculatePrintTimeRemaining(
    Spool spool, {
    double printSpeed = 50.0, // mm/s
    double layerHeight = 0.2, // mm
    double infillPercentage = 20.0, // %
  });

  /// Calculate estimated remaining weight
  double? calculateRemainingWeight(
    Spool spool, {
    double? materialDensity, // g/cm³
    double? filamentDiameter, // mm
  });

  /// Calculate usage statistics for a period
  UsageStatistics calculateUsageStatistics(
    List<Spool> spools, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Predict when spool will be empty based on usage pattern
  DateTime? predictEmptyDate(
    Spool spool,
    List<UsageRecord> usageHistory,
  );

  /// Calculate cost per unit length/weight
  SpoolCostAnalysis calculateCostAnalysis(
    Spool spool, {
    required double purchasePrice,
    double? totalWeight,
  });
}

/// Estimated print time result
class EstimatedPrintTime {
  final Duration totalTime;
  final double confidence; // 0.0 to 1.0
  final List<String> assumptions;

  const EstimatedPrintTime({
    required this.totalTime,
    required this.confidence,
    this.assumptions = const [],
  });

  /// Get time in hours
  double get hours => totalTime.inMinutes / 60.0;

  /// Get formatted time string
  String get formatted {
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

/// Usage statistics for analysis
class UsageStatistics {
  final int totalSpools;
  final FilamentLength totalLengthUsed;
  final FilamentLength totalLengthRemaining;
  final double averageUsagePercentage;
  final int nearlyEmptySpools;
  final int emptySpools;
  final Map<String, int> materialTypeCount;
  final Map<String, int> manufacturerCount;

  const UsageStatistics({
    required this.totalSpools,
    required this.totalLengthUsed,
    required this.totalLengthRemaining,
    required this.averageUsagePercentage,
    required this.nearlyEmptySpools,
    required this.emptySpools,
    required this.materialTypeCount,
    required this.manufacturerCount,
  });
}

/// Usage record for tracking consumption over time
class UsageRecord {
  final DateTime date;
  final FilamentLength lengthUsed;
  final Duration printTime;
  final String? projectName;

  const UsageRecord({
    required this.date,
    required this.lengthUsed,
    required this.printTime,
    this.projectName,
  });
}

/// Cost analysis result
class SpoolCostAnalysis {
  final double costPerMeter;
  final double? costPerGram;
  final double totalValue;
  final double remainingValue;
  final double usedValue;

  const SpoolCostAnalysis({
    required this.costPerMeter,
    this.costPerGram,
    required this.totalValue,
    required this.remainingValue,
    required this.usedValue,
  });

  /// Get cost efficiency (lower is better)
  double get costEfficiency => costPerMeter;
}