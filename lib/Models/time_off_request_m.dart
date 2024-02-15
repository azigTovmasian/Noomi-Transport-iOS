class TimeOffRequestM {
  final int status;
  final DateTime updatedAt;

  TimeOffRequestM({
    required this.status,
    required this.updatedAt,
  });

  factory TimeOffRequestM.fromJson(Map<String, dynamic> json) {
    return TimeOffRequestM(
      status: json['Stauts'] ?? '',
      updatedAt: DateTime.parse(json['UpdatedAt'] ?? ''),
    );
  }
}
