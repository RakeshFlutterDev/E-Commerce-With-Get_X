import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _userRef = FirebaseDatabase.instance.reference().child('users');

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String firstName, String lastName, String phone) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await saveUserData(firstName, lastName, email, phone, user.uid);
        return user;
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }

    return null;
  }

  Future<void> saveUserData(
      String firstName, String lastName, String email, String phone, String uid) async {
    try {
      String userId = await generateUserId();

      await _userRef.child(userId).set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      print('Error saving user data: $e');
      throw 'Failed to save user data. Please try again.';
    }
  }

  Future<String> generateUserId() async {
    DataSnapshot dataSnapshot = await _userRef.once();

    bool hasUsers = dataSnapshot.value != null;

    if (hasUsers) {
      Map<dynamic, dynamic>? userMap = dataSnapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null) {
        List<String> userIds = userMap.keys.cast<String>().toList();
        if (userIds.isNotEmpty) {
          userIds.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
          String lastUserId = userIds.first;

          int newUserId = int.parse(lastUserId) + 1;

          return newUserId.toString();
        }
      }
    }

    return '10001';
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DataSnapshot snapshot = await _userRef.child(uid).once();

      if (snapshot.value != null) {
        dynamic value = snapshot.value;

        Map<String, dynamic> userDetails = Map<String, dynamic>.from(value);

        String email = userDetails['email'];
        String firstName = userDetails['first_name'];
        String lastName = userDetails['last_name'];
        String phone = userDetails['phone'];

        return UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return null;
    }
  }
}

class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}

// void main() async {
//   FirebaseService firebaseService = FirebaseService();
//   await fetchUserDetails(firebaseService);
// }

void fetchUserDetails(FirebaseService firebaseService) async {
  User? currentUser = firebaseService.getCurrentUser();

  if (currentUser != null) {
    String uid = currentUser.uid;

    UserModel? userModel = await firebaseService.getUserDetails(uid);
    if (userModel != null) {
      String email = userModel.email;
      String firstName = userModel.firstName;
      String lastName = userModel.lastName;
      String phone = userModel.phone;

      print('Email: $email');
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Phone: $phone');
    } else {
      print('User details not found');
    }
  } else {
    print('User not logged in');
  }
}
