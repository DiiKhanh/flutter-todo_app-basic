import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToEditPage;
  final Function(String) deleteById;
  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateToEditPage,
      required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title'].toString()),
        subtitle: Text(item['description'].toString()),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateToEditPage(item);
            } else if (value == 'delete') {
              deleteById(id);
            }
          },
          itemBuilder: (context) {
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
          },
        ),
      ),
    );
  }
}
