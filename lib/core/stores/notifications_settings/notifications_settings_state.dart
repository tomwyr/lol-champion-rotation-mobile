import '../../model/notifications.dart';
import '../../state.dart';

typedef NotificationsSettingsState = DataState<NotificationsSettings>;

enum NotificationsSettingsEvent {
  loadSettingsError,
  updateSettingsError,
  notificationsPermissionDenied,
}
