class FocusSession {
  final int? id;
  final int? actualLength;
  final String? endTime;
  final String? expectedEndTime;
  final int expectedLength;
  final String? name;
  final String? sessionDate;
  final String? startTime;
  final String? status;

  FocusSession(
      {this.id,
      this.actualLength,
      this.endTime,
      this.expectedEndTime,
      required this.expectedLength,
      this.name,
      this.sessionDate,
      this.startTime,
      this.status});

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
        id: json["id"],
        actualLength: json['actual_length'],
        endTime: json['end_time'],
        expectedEndTime: json['expected_end_time'],
        expectedLength: json['expected_length'],
        name: json["name"],
        sessionDate: json['session_date'],
        startTime: json['start_time'],
        status: json['status']);
  }
}
