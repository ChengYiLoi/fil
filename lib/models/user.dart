import 'package:cloud_firestore/cloud_firestore.dart';

class UserObj {
  Timestamp creationTime;
  String dailyGoal;
  List dailyIntake;
  String email;
  List <dynamic> recipeFavs;
  Map<String, dynamic> reminders;
  String uid;

  UserObj(this.creationTime, this.dailyGoal, this.dailyIntake, this.email,
      this.recipeFavs, this.reminders, this.uid);

  // update user daily goal
  // void updateUserGoal(int value) {
  //   this.dailyGoal = value.toString();
  // }

  List<dynamic> get recipe_favs {
    return recipeFavs;
  }

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
    if (int.parse(dailyGoal) < int.parse(daily_intake)) {
      return 1.0;
    }
    return (int.parse(daily_intake) / int.parse(dailyGoal));
  }
}
