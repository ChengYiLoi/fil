class UserObj {
  String uid;
  String dailyGoal;
  String dailyIntake;
  String creationTime;
  String email;

  UserObj({this.uid, this.dailyGoal, this.dailyIntake, this.creationTime, this.email});

  // update user daily goal
  void updateUserGoal(int value) {
    this.dailyGoal = value.toString();
  }
}
