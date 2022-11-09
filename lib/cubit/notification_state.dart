part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.settings,
  });

  final List<Map<String, dynamic>> settings;

  @override
  List<Object> get props => [settings];
}
