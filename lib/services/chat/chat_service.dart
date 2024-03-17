import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_learning/models/message.dart';

class ChatService {
  // get instance of firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // get user stream
  /*
    List<Map<String, dynamic>> = [{
        'email': 'test@gmail.com',
        'uid': '123456'
    },
    {
        'email': 'test2@gmail.com',
        'uid': '1234567'
    }]
   */

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual document
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    // create a new message
    final messageData = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room iD for the two users (sorted to ensure uniqueness)
    String chatRoomID = constructChatRoomID(currentUserID, receiverID);

    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(messageData.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room iD for the two users (sorted to ensure uniqueness)
    String chatRoomID = constructChatRoomID(userID, otherUserID);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // construct chat room iD for the two users (sorted to ensure uniqueness)
  String constructChatRoomID(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    return ids.join('_');
  }
}
