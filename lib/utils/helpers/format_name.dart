String formatPatientName(String fullName) {
  fullName = fullName.trim();
  if (fullName.isEmpty) return "--";

  // Return as-is if name length is 12 characters or fewer
  if (fullName.length <= 12) return fullName;

  List<String> parts = fullName.split(RegExp(r'\s+'));
  if (parts.isEmpty) return "--";

  String firstName = parts.first;
  String lastInitial = parts.length > 1 ? parts.last[0].toUpperCase() : "";

  return lastInitial.isNotEmpty ? "$firstName $lastInitial." : firstName;
}
