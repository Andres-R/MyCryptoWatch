import 'package:bloc/bloc.dart';
import 'package:crypto_prices/data/database/database_controller.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.userID,
    required this.screenID,
  }) : super(const NotificationState(settings: [])) {
    initializeSettings();
  }

  DatabaseController dbController = DatabaseController();
  int userID;
  int screenID;

  void initializeSettings() async {
    List<Map<String, dynamic>> settings =
        await dbController.getNotificationSettings(userID, screenID);
    emit(NotificationState(settings: settings));
  }

  void addNotificationSetting(
    String name,
    String symbol,
    String criteria,
    double criteriaPercent,
    int userID,
    int screenID,
  ) async {
    await dbController.addNotificationSetting(
        name, symbol, criteria, criteriaPercent, userID, screenID);
    List<Map<String, dynamic>> settings =
        await dbController.getNotificationSettings(userID, screenID);
    emit(NotificationState(settings: settings));
  }

  void deleteNotificationByID(int id, int userID, int screenID) async {
    await dbController.deleteNotificationSettingByID(id);
    List<Map<String, dynamic>> settings =
        await dbController.getNotificationSettings(userID, screenID);
    emit(NotificationState(settings: settings));
  }
}
