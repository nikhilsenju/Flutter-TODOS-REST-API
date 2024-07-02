import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigatedit;
  final Function(String) delebyid;

  const Mycard({
    super.key,
    required this.index,
    required this.item,
    required this.navigatedit,
    required this.delebyid,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'edit') {
            navigatedit(item);
          } else if (value == 'delete') {
            delebyid(id);
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        }),
      ),
    );
  }
}
