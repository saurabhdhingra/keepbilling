class ToDoTask {
    ToDoTask({
        required this.id,
        required this.descrip,
        required this.dates,
    });

    String id;
    String descrip;
    String dates;

     factory ToDoTask.fromMap(Map<String, dynamic> json) => ToDoTask(
        id: json["id"],
        descrip: json["descrip"],
        dates: json["dates"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "descrip": descrip,
        "dates": dates,
    };
}