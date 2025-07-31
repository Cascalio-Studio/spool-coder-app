import '../value_objects/rfid_data.dart';
import '../value_objects/material_type.dart';
import '../value_objects/temperature_profile.dart';
import '../entities/spool.dart';

/// Domain service for RFID-related business operations
/// Part of the Domain Layer: encapsulates complex RFID business logic
class SpoolRfidService {
  /// Validate RFID data integrity and completeness
  List<String> validateRfidData(RfidData rfidData) {
    final issues = <String>[];

    // Check basic completeness
    if (rfidData.uid.isEmpty || rfidData.uid == 'UNKNOWN') {
      issues.add('Invalid or missing UID');
    }

    if (rfidData.filamentType == null || rfidData.filamentType!.isEmpty) {
      issues.add('Missing filament type information');
    }

    if (rfidData.detailedFilamentType == null || rfidData.detailedFilamentType!.isEmpty) {
      issues.add('Missing detailed filament type');
    }

    // Validate temperature profile
    if (rfidData.temperatureProfile != null && 
        !rfidData.temperatureProfile!.isValid) {
      issues.add('Invalid temperature profile data');
    }

    // Check production info validity
    if (rfidData.productionInfo != null) {
      if (rfidData.productionInfo!.materialId != null &&
          !rfidData.productionInfo!.hasValidMaterialId) {
        issues.add('Invalid Bambu Lab material ID format');
      }
    }

    // Validate physical measurements
    if (rfidData.filamentDiameter != null) {
      if (rfidData.filamentDiameter! < 1.0 || rfidData.filamentDiameter! > 5.0) {
        issues.add('Unusual filament diameter: ${rfidData.filamentDiameter}mm');
      }
    }

    if (rfidData.spoolWeight != null) {
      if (rfidData.spoolWeight! < 10 || rfidData.spoolWeight! > 5000) {
        issues.add('Unusual spool weight: ${rfidData.spoolWeight}g');
      }
    }

    // Check for Bambu Lab authenticity
    if (!rfidData.isGenuineBambuLab) {
      issues.add('Warning: No valid RSA signature found - may not be genuine Bambu Lab');
    }

    return issues;
  }

  /// Check material compatibility between RFID data and expected type
  bool isMaterialCompatible(RfidData rfidData, MaterialType expectedType) {
    if (rfidData.detailedFilamentType != null) {
      final rfidMaterial = MaterialType.fromRfidDetailedType(rfidData.detailedFilamentType!);
      return rfidMaterial.value == expectedType.value;
    }

    if (rfidData.filamentType != null) {
      final rfidMaterial = MaterialType.fromString(rfidData.filamentType!);
      // Allow broader compatibility for basic types
      return rfidMaterial.value.startsWith(expectedType.value) ||
             expectedType.value.startsWith(rfidMaterial.value);
    }

    return false;
  }

  /// Generate printing recommendations based on RFID data
  Map<String, dynamic> generatePrintingRecommendations(RfidData rfidData) {
    final recommendations = <String, dynamic>{};

    // Temperature recommendations
    if (rfidData.temperatureProfile != null) {
      final tempProfile = rfidData.temperatureProfile!;
      
      if (tempProfile.recommendedHotendTemperature != null) {
        recommendations['hotend_temperature'] = tempProfile.recommendedHotendTemperature;
      }
      
      if (tempProfile.bedTemperature != null) {
        recommendations['bed_temperature'] = tempProfile.bedTemperature;
      }

      // Drying recommendations
      if (tempProfile.needsDrying) {
        recommendations['drying_required'] = true;
        recommendations['drying_temperature'] = tempProfile.dryingTemperature;
        recommendations['drying_hours'] = tempProfile.dryingTimeHours;
      }
    }

    // Nozzle compatibility
    if (rfidData.nozzleDiameter != null) {
      recommendations['recommended_nozzle'] = '${rfidData.nozzleDiameter}mm';
    }

    // Filament diameter
    if (rfidData.filamentDiameter != null) {
      recommendations['filament_diameter'] = rfidData.filamentDiameter;
    }

    // Material-specific recommendations
    if (rfidData.detailedFilamentType != null) {
      final materialType = MaterialType.fromRfidDetailedType(rfidData.detailedFilamentType!);
      recommendations['material_type'] = materialType.displayName;
      
      // Add specific recommendations based on material
      if (materialType == MaterialType.plaCf) {
        recommendations['hardened_nozzle'] = 'Required for abrasive carbon fiber';
      }
      
      if (materialType == MaterialType.supportPla) {
        recommendations['use_case'] = 'Support material only';
      }
    }

    // Freshness recommendations
    if (rfidData.productionInfo != null) {
      final productionInfo = rfidData.productionInfo!;
      
      if (productionInfo.isOld) {
        recommendations['freshness_warning'] = 'Filament is over 2 years old - check quality';
      } else if (productionInfo.isFresh) {
        recommendations['freshness_status'] = 'Fresh filament - optimal quality';
      }
    }

    return recommendations;
  }

  /// Calculate estimated cost per gram based on RFID spool data
  double? estimateCostPerGram(RfidData rfidData, {double? totalSpoolCost}) {
    if (totalSpoolCost == null || rfidData.spoolWeight == null) return null;
    
    return totalSpoolCost / rfidData.spoolWeight!;
  }

  /// Analyze RFID data for potential issues or warnings
  List<String> analyzeForWarnings(RfidData rfidData) {
    final warnings = <String>[];

    // Age-related warnings
    if (rfidData.productionInfo != null) {
      final productionInfo = rfidData.productionInfo!;
      
      if (productionInfo.isOld) {
        warnings.add('Filament is over 2 years old - may have degraded quality');
      }
    }

    // Temperature profile warnings
    if (rfidData.temperatureProfile != null) {
      final tempProfile = rfidData.temperatureProfile!;
      
      if (tempProfile.needsDrying) {
        warnings.add('Filament requires drying before use');
      }

      if (tempProfile.maxHotendTemperature != null && 
          tempProfile.maxHotendTemperature! > 280) {
        warnings.add('High temperature material - ensure printer compatibility');
      }
    }

    // Material-specific warnings
    if (rfidData.detailedFilamentType != null) {
      final materialType = MaterialType.fromRfidDetailedType(rfidData.detailedFilamentType!);
      
      if (materialType == MaterialType.plaCf) {
        warnings.add('Abrasive material - use hardened nozzle and check for wear');
      }
    }

    // Physical measurement warnings
    if (rfidData.nozzleDiameter != null && rfidData.nozzleDiameter! > 0.6) {
      warnings.add('Optimized for large nozzle sizes');
    }

    return warnings;
  }

  /// Check if two RFID scans represent the same physical spool
  bool isSameSpool(RfidData rfid1, RfidData rfid2) {
    // UIDs should match exactly
    if (rfid1.uid != rfid2.uid) return false;

    // Production info should be compatible
    if (rfid1.productionInfo != null && rfid2.productionInfo != null) {
      final prod1 = rfid1.productionInfo!;
      final prod2 = rfid2.productionInfo!;
      
      if (prod1.materialId != null && prod2.materialId != null) {
        if (prod1.materialId != prod2.materialId) return false;
      }
      
      if (prod1.productionDateTime != null && prod2.productionDateTime != null) {
        if (prod1.productionDateTime != prod2.productionDateTime) return false;
      }
    }

    return true;
  }
}