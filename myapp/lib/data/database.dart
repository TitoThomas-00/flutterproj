import 'package:hive_flutter/hive_flutter.dart';
class ToDoDataBase{

  List toDoList = [];

// reference  box
final _myBox = Hive.box('mybox');

//run this method if this is the 1stt time opening app
void createInitialData() {
  toDoList = [
    ["Default Task", false],
    ["2nd Task", false],
  ];
}

//load data
void loadData()  {
  toDoList = _myBox.get("TODOLIST");
}
//update data
void updateDatabase() {
  _myBox.put("TODOLIST", toDoList);

}

}