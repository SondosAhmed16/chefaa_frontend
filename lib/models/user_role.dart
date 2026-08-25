enum UserRole { doctor, patient, facility, pharmacy, lab }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.doctor:
        return 'doctor';
      case UserRole.patient:
        return 'patient';
      case UserRole.facility:
        return 'facility'; 
      case UserRole.pharmacy:
        return 'pharmacy';
      case UserRole.lab:
        return 'lab';
    }
  }

  String get title {
    switch (this) {
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
      case UserRole.facility:
        return 'Facility';
      case UserRole.pharmacy:
        return 'Pharmacy';
      case UserRole.lab:
        return 'Medical Lab/\nRadiology Center';
    }
  }

  bool get isFinalRole => this != UserRole.facility;
}