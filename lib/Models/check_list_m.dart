class CheckListM {
 
String checkListItem;
  CheckListM({
    required this.checkListItem
  });

  factory CheckListM.fromJson(dynamic json) {
    return CheckListM(
      checkListItem: json["\$values"],
    );
  }

  static List<CheckListM> checkListFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return CheckListM.fromJson(data);
    }).toList();
  }
}
