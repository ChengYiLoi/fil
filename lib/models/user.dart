import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserObj {
  Timestamp creationTime;
  String dailyGoal;
  Map<String, dynamic> dailyIntake;
  String email;
  bool isMetric;
  List<dynamic> recipeFavs;
  Map<String, dynamic> reminders;
  String uid;

  UserObj(this.creationTime, this.dailyGoal, this.dailyIntake, this.email,
      this.isMetric, this.recipeFavs, this.reminders, this.uid);

  // update user daily goal
  // void updateUserGoal(int value) {
  //   this.dailyGoal = value.toString();
  // }
  setMeasurement(bool value) {
    isMetric = value;
  }

  String getDailyIntake() {
    int total = 0;
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    String now = formatter.format(DateTime.now());
    if (dailyIntake[now] != null) {
      dailyIntake[now].forEach((amount) {
        if (amount != "") {
          total += int.parse(amount);
        }
      });
    }
    return total.toString();
  }

  double getRemainder() {
    if (int.parse(dailyGoal) < int.parse(getDailyIntake())) {
      return 1.0;
    }
    return (int.parse(getDailyIntake()) / int.parse(dailyGoal));
  }
}
