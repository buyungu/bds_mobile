import 'package:intl/intl.dart'; // Keep this import if you might use DateFormat for other purposes, but not directly for 'timeAgo' now.

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String? time; // This is the raw string from Laravel (e.g., "2 minutes ago")
  final String type;
  final int? eventId; // Assuming this is used for event notifications
  final int? bloodRequestId; // Assuming this is used for blood request notifications
  final bool important;
  final String? status; // e.g., 'read', 'unread'
  final String? errorMessage;
  final int? userId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.time,
    required this.type,
    required this.eventId,
    required this.bloodRequestId, 
    required this.important,
    this.status,
    this.errorMessage,
    this.userId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      time: json['time'] as String?, // Directly use the string from Laravel
      type: json['type'] as String,
      eventId: json['event_id'] as int?, // Nullable if not applicable
      bloodRequestId: json['blood_request_id'] as int?, // Nullable if not applicable
      important: json['important'] as bool? ?? false, // Default to false if null
      status: json['status'] as String?,
      errorMessage: json['error_message'] as String?,
      userId: json['user_id'] as int?,
    );
  }

  // Method to create a copy of the NotificationItem with updated properties
  NotificationItem copyWith({
    int? id,
    String? title,
    String? message,
    String? time,
    String? type,
    int? eventId,
    int? bloodRequestId,
    bool? important,
    String? status,
    String? errorMessage,
    int? userId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      eventId: eventId ?? this.id, // Assuming id is used for eventId
      bloodRequestId: bloodRequestId ?? this.id, // Assuming id is used for bloodRequestId
      important: important ?? this.important,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      userId: userId ?? this.userId,
    );
  }

  // CORRECTED: This getter now simply returns the 'time' string directly
  // as it's already in the desired human-readable format from Laravel.
  String get timeAgo {
    return time ?? 'N/A'; // Return the time string, or 'N/A' if null
  }
}