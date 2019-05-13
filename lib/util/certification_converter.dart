import 'package:flutter/material.dart';

class CertificationConverter {
  static const String _g_ru = "0+";
  static const String _g_nl = "AL";
  static const String _pg_ru = "6+";
  static const String _pg_hu = "6";

  //No supported country has pg-12
  static const String _pg15_au = "MA15+";
  static const String _r_ru = "18+";
  static const String _r_hu = "18";

  static const String certificationG = "普遍級";
  static const String certificationPg = "保護級";
  static const String certificationPg12 = "輔12級";
  static const String certificationPg15 = "輔15級";
  static const String certificationR = "限制級";

  List<String> _certifications;

  CertificationConverter(this._certifications);

  String getTwCertification() {
    bool allNonNull = true;

    for (var cert in _certifications) {
      String countryCode = "countryCode";
      String certification = "certification";
      if (countryCode == "AU") {
        allNonNull &= certification != null && certification.isNotEmpty;
        if (_pg15_au == certification) {
          return certificationPg15;
        }
      }
      if (countryCode == "NL") {
        allNonNull &= certification != null && certification.isNotEmpty;
        if (_g_nl == certification) {
          return certificationG;
        }
      }
      if (countryCode == "HU") {
        allNonNull &= certification != null && certification.isNotEmpty;
        if (_pg_hu == certification) {
          return certificationG;
        } else if (_r_hu == certification) {
          return certificationR;
        }
      }
      if (countryCode == "RU") {
        allNonNull &= certification != null && certification.isNotEmpty;
        if (_g_ru == certification) {
          return certificationG;
        } else if (_pg_ru == certification) {
          return certificationPg;
        } else if (_r_ru == certification) {
          return certificationR;
        }
      }
    }
    if (allNonNull) {
      return certificationPg12;
    }
    return "";
  }

  Color getCertificationColor(String certification) {
    Color color;
    switch (certification) {
      case certificationG:
        color = const Color.fromARGB(255, 92, 182, 46);
        break;
      case certificationPg:
        color = const Color.fromARGB(255, 85, 162, 234);
        break;
      case certificationPg12:
        color = const Color.fromARGB(255, 250, 209, 73);
        break;
      case certificationPg15:
        color = const Color.fromARGB(255, 239, 122, 57);
        break;
      case certificationR:
        color = const Color.fromARGB(255, 231, 54, 49);
        break;
      default:
        color = Colors.white;
    }
    return color;
  }
}
