import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      "New cattle added!",
      "Your herd has increased.",
      "2h ago",
      true,
    ),
    NotificationItem(
      "Milk production update",
      "Today's report is available.",
      "5h ago",
      false,
    ),
    NotificationItem(
      "Milk production update",
      "Today's report is available.",
      "8h ago",
      true,
    ),
    NotificationItem(
      "Feeding reminder",
      "Time to feed the cattle.",
      "Yesterday",
      false,
    ),
    NotificationItem(
      "Milk production update",
      "Today's report is available.",
      "2day ago",
      false,
    ),
  ];

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  void _dismissNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: const Text(
              "Clear All",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Center(
                child: Text(
                  "No notifications",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Dismissible(
                  key: Key(notification.title),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => _dismissNotification(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            notification.isUnread ? Colors.blue : Colors.grey,
                        child: const Icon(
                          FeatherIcons.bell,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notification.description),
                      trailing: Text(
                        notification.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  NotificationItem(
    this.title,
    this.description,
    this.time,
    this.isUnread,
  );
}
