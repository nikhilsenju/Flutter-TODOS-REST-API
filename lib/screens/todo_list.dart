
import 'package:flutter/material.dart';
import 'package:todos/screens/add_page.dart';
import 'package:todos/screens/utlis/snackbar_helper.dart';
import 'package:todos/services/todo_services.dart';
import 'package:todos/widget/card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Todo List')),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isEmpty,
            replacement: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
               return Mycard(index: index, item: item, navigatedit: navigateToEditpage, delebyid:deleteById);
              },
            ),
            child: Center(
                child: Text(
              'NO TODO ITEM',
              style: Theme.of(context).textTheme.headlineLarge,
            )),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddoage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToEditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddoage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // delete the item//
    // remove the item and refresh//
    // ignore: non_constant_identifier_names
    final IsSuccess = await TodoServices.deleteById(id);
    if (IsSuccess) {
      final filterd = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filterd;
      });
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoServices.fetchToDo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context,message:'Something Went Wrong');
    }
    setState(() {
      isloading = false;
    });
  }

}
