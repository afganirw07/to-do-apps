import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;

  List<dynamic> _todos = [];
  bool _loading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fetchTodos();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // get data todo
  Future<void> _fetchTodos() async {
    setState(() => _loading = true);
    try {
      final user = supabase.auth.currentUser;
      final response = await supabase
          .from('todos')
          .select()
          .eq('user_id', user!.id)
          .order('created_at', ascending: false);

      setState(() {
        _todos = response;
        _loading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() => _loading = false);
      _showErrorSnackBar("Error fetch todos: $e");
    }
  }

  // add todo
  Future<void> _addTodo(String title, String description) async {
    try {
      final user = supabase.auth.currentUser;
      await supabase.from('todos').insert({
        'user_id': user!.id,
        'title': title,
        'description': description,
      });
      _fetchTodos();
      _showSuccessSnackBar("Todo successfully added!");
    } catch (e) {
      _showErrorSnackBar("Error add todo: $e");
    }
  }

  // update todo
  Future<void> _updateTodo(String id, String title, String description) async {
    try {
      await supabase.from('todos').update({
        'title': title,
        'description': description,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
      _fetchTodos();
      _showSuccessSnackBar("Todo successfully updated!");
    } catch (e) {
      _showErrorSnackBar("Error update todo: $e");
    }
  }

  // done 
  Future<void> _toggleComplete(String id, bool current) async {
    try {
      await supabase
          .from('todos')
          .update({'is_completed': !current}).eq('id', id);
      _fetchTodos();
    } catch (e) {
      _showErrorSnackBar("Error toggle: $e");
    }
  }

  // delete
  Future<void> _deleteTodo(String id) async {
    try {
      await supabase.from('todos').delete().eq('id', id);
      _fetchTodos();
      _showSuccessSnackBar("Todo successfully deleted!");
    } catch (e) {
      _showErrorSnackBar("Error delete todo: $e");
    }
  }

  // show snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // show error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // edit todo
  void _showTodoDialog({String? id, String? currentTitle, String? currentDesc}) {
    final titleController = TextEditingController(text: currentTitle ?? "");
    final descController = TextEditingController(text: currentDesc ?? "");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      id == null ? Icons.add_task : Icons.edit_note,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    id == null ? "Add New Todo" : "Edit Todo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Tittle",
                  prefixIcon: Icon(Icons.title, color: Colors.blue.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description, color: Colors.blue.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) {
                        _showErrorSnackBar("The todo title cannot be empty!");
                        return;
                      }
                      
                      if (id == null) {
                        _addTodo(titleController.text.trim(), descController.text.trim());
                      } else {
                        _updateTodo(id, titleController.text.trim(), descController.text.trim());
                      }
                      Navigator.pop(ctx);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(id == null ? Icons.add : Icons.save),
                        const SizedBox(width: 8),
                        Text(
                          id == null ? "Add" : "Save",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade400,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.checklist_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "My Todo List",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${_todos.where((todo) => !todo['is_completed']).length} remaining tasks",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_todos.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "${_todos.where((todo) => todo['is_completed']).length}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Done",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "${_todos.length}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Content Section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : _todos.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.assignment_turned_in,
                                      size: 64,
                                      color: Colors.blue.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No todo yet",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tap the + button to add the first todo.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : FadeTransition(
                              opacity: _fadeAnimation,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: _todos.length,
                                itemBuilder: (ctx, i) {
                                  final todo = _todos[i];
                                  final isCompleted = todo['is_completed'] ?? false;
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: isCompleted 
                                          ? Colors.green.shade50 
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: isCompleted 
                                            ? Colors.green.shade200 
                                            : Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: GestureDetector(
                                        onTap: () => _toggleComplete(
                                          todo['id'], 
                                          isCompleted,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: isCompleted 
                                                ? Colors.green 
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isCompleted 
                                                  ? Colors.green 
                                                  : Colors.blue.shade400,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: isCompleted
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                )
                                              : null,
                                        ),
                                      ),
                                      title: Text(
                                        todo['title'] ?? "",
                                        style: TextStyle(
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isCompleted 
                                              ? Colors.grey.shade600 
                                              : Colors.grey.shade800,
                                        ),
                                      ),
                                      subtitle: todo['description']?.isNotEmpty == true
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                todo['description'],
                                                style: TextStyle(
                                                  decoration: isCompleted
                                                      ? TextDecoration.lineThrough
                                                      : null,
                                                  color: isCompleted 
                                                      ? Colors.grey.shade500 
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            )
                                          : null,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.blue.shade600,
                                                size: 20,
                                              ),
                                              onPressed: () => _showTodoDialog(
                                                id: todo['id'],
                                                currentTitle: todo['title'],
                                                currentDesc: todo['description'],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red.shade600,
                                                size: 20,
                                              ),
                                              onPressed: () => _deleteTodo(todo['id']),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showTodoDialog(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}