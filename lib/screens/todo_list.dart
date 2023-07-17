import 'package:flutter/material.dart';
import 'package:flutter_basic/screens/add_page.dart';
import 'package:flutter_basic/services/todo_service.dart';
import 'package:flutter_basic/utils/snackbar_helper.dart';
import 'package:flutter_basic/widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // state
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
                child: Text(
              'No Todo item',
            )),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateToEditPage: navigateToEditPage,
                    deleteById: deleteById);
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add Todo')),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final itemsFiltered =
          items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = itemsFiltered;
      });
    } else {
      showMessageError(context, message: 'Delete Failed!');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showMessageError(context, message: 'Fetch Data Failed!');
    }
  }
}
