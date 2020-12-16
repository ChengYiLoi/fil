import 'package:cloud_firestore/cloud_firestore.dart';

class UserObj {
  String uid;
  String dailyGoal;
  List dailyIntake;
  Timestamp creationTime;
  String email;

  UserObj(this.creationTime, this.dailyGoal, this.dailyIntake, this.email,
      this.uid);

  // update user daily goal
  // void updateUserGoal(int value) {
  //   this.dailyGoal = value.toString();
  // }

  String get daily_intake {
    int total = 0;
    dailyIntake.forEach((amount) {
      if (amount != "") {
        total += int.parse(amount);
      }
    });
    return total.toString();
  }

  String get daily_goal {
    return dailyGoal;
  }

  String get userID {
    return uid;
  }

  double get remainder {
    return (int.parse(daily_intake) / int.parse(dailyGoal));
  }
}
