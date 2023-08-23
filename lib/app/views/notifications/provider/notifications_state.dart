import 'package:flutter/material.dart';

import '/models/notification.dart';

class NotificationsState extends ChangeNotifier {
  bool _isLoading = true;

  List<NotificationModel> _notifications = <NotificationModel>[];
  int _count = 0;

  bool get isLoading => _isLoading;

  List<NotificationModel> get notifications => _notifications;
  int get count => _count;

  void isRequestLoading(bool loading) {
    _isLoading = loading;

    if (!loading) notifyListeners();
  }

  void getNotifications(List<NotificationModel> elements) {
    _notifications = elements;

    final List<NotificationModel> unread = List.from(elements);
    unread.removeWhere((e) => e.status == 1); // unread element is e.status = 0.
    _count = unread.length;

    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _count = 0;
    notifyListeners();
  }
}
