import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_basic/services/todo_service.dart';
import 'package:flutter_basic/utils/snackbar_helper.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titleController.text = title;
      desController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Title'),
            controller: titleController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: desController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(isEdit ? 'Update' : 'Submit')),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      showMessageError(context,
          message: 'You cann\'t call method update without data');
      return;
    }
    final id = todo['_id'];
    final isSuccess = await TodoService.updateData(id, body);
    if (isSuccess) {
      showMessageSuccess(context, message: "Updated success");
    } else {}
  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.submitData(body);
    if (isSuccess) {
      showMessageSuccess(context, message: "Create success");
    } else {
      showMessageError(context, message: "Create Fail");
    }
  }

  Map get body {
    final title = titleController.text;
    final des = desController.text;
    return {"title": title, "description": des, "is_completed": false};
  }
}
