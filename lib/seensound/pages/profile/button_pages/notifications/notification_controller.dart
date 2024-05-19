import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  var hasUnreadNotifications = false.obs;

  void addNotification(String title, String message, bool isError) {
    notifications.add(NotificationItem(title: title, message: message, isError: isError));
    hasUnreadNotifications.value = true;
  }

  void markAllAsRead() {
    notifications.forEach((notification) {
      notification.isRead = true;
    });
    hasUnreadNotifications.value = false;
  }

  void deleteNotification(int index) {
    notifications.removeAt(index);
    if (notifications.any((notification) => !notification.isRead)) {
      hasUnreadNotifications.value = true;
    } else {
      hasUnreadNotifications.value = false;
    }
  }

  void deleteAllNotifications() {
    notifications.clear();
    hasUnreadNotifications.value = false;
  }
}

class NotificationItem {
  String title;
  String message;
  bool isError;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    this.isError = false,
    this.isRead = false,
  });
}
