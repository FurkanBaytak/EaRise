import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:EaRise/seensound/main_page/seensound_theme.dart';
import 'notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler', style: TextStyle(color: SeenSoundTheme.darkText)),
        backgroundColor: SeenSoundTheme.white,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: SeenSoundTheme.nearlyDarkBlue),
            onPressed: notificationController.markAllAsRead,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: SeenSoundTheme.nearlyDarkBlue),
            onPressed: notificationController.deleteAllNotifications,
          ),
        ],
      ),
      body: Obx(
            () {
          return ListView.builder(
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationController.notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () {
                  notification.isRead = true;
                  notificationController.notifications[index] = notification;
                  if (!notificationController.notifications.any((notification) => !notification.isRead)) {
                    notificationController.hasUnreadNotifications.value = false;
                  }
                },
                onDelete: () {
                  notificationController.deleteNotification(index);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(notification.isError ? Icons.error : Icons.notifications, color: notification.isError ? Colors.red : Colors.blue),
        title: Text(notification.title, style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold)),
        subtitle: Text(notification.message),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.grey),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
