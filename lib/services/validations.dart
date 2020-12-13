dynamic validateEmail(String email) {
  if (email == "") {
    return "Email cannot be empty";
  } else if (!email.contains("@")) {
    return "Email is not valid";
  }
  return null;
}

dynamic validatePassword(String password) {
  if (password == "") {
    return "Password cannot be empty";
  } else if (password.length < 6) {
    return "Password needs to be at least 6 characters";
  }
  return null;
}
