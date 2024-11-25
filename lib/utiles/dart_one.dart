class Students{
  String? id;
  String? name;
  String? course;
  String? address;
  int? status;

  //*Constructor
  Students({this.id,this.name,this.course,this.address,this.status});

  //* Named Constructor  (ingott varunna Json ne Dart aakki maatanam)
  factory Students.FromJson(Map<String,dynamic>json){
    return Students(

      id: json['id'],
      name: json['name'],
      course: json['course'],
      address: json['address'],
      status: json['status'],
    );
  }
}