import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokumoku_a/model/message.dart';
import 'package:mokumoku_a/model/user.dart';

class Firestore {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('users');
  static final roomRef = _firestoreInstance.collection('rooms');

  // ユーザ情報取得
  static Future<UserModel> getProfile(String uid) async {
    final profile = await userRef.doc(uid).get();
    UserModel myProfile = UserModel(
      color: profile.data()?['color'] ?? 0,
      uid: uid,
      imageIndex: profile.data()?['imageIndex'] ?? 0,
    );
    return myProfile;
  }

  // 部屋にはいれるかどうか 入れなくなったらモデルのroomInをfalseに変更
  static Future<void> updateRoomIn(documentId, roomIn) {
    return roomRef
        .doc(documentId)
        .update({'roomIn': roomIn })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // rooms > 部屋のドキュメント > 値・usersのコレクション, 部屋のユーザについての処理
  // 部屋に入るときにroomsのusersにuserを追加
  static Future<void> addUsers(roomId, userDocumentId) async {
    return await getProfile(userDocumentId).then((user) {
      roomRef
      .doc(roomId)
      .collection('users')
      .doc(userDocumentId)
      .set({'color': user.color, 'imageIndex': user.imageIndex, 'inTime': Timestamp.now(), 'inRoom': true})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
    });
  }

  // 勉強部屋内
  static Future<List> getUsers(String roomId, String myUid, List inRoomUserList) async {
    final getRoomUsers = roomRef
              .doc(roomId).collection('users')
              .where('inRoom', isEqualTo: true)
              .orderBy("inTime")
              .limit(10);
          
    final snapshot = await getRoomUsers.get();
    List roomUsersList = [];
    await Future.forEach(snapshot.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
      if(doc.id != myUid) {
        UserModel user = await getProfile(doc.id);
        UserModel userProfile = UserModel(
          color: user.color,
          uid: user.uid,
          imageIndex: user.imageIndex
        );
        roomUsersList.add(userProfile);
      }
    });
    return roomUsersList;
  }

  static Future<void> sendMessage(String roomDocumentId, String userId, String message, int color, int imageIndex) async{
    return await roomRef
        .doc(roomDocumentId)
        .collection('messages')
        .doc()
        .set({
          'createdAt': Timestamp.now(),
          'message': message,
          'uid': userId,
          'color': color,
          'imageIndex': imageIndex,
        });
  }

  static Future<void> getOutRoom(roomDocumentId, userDocumentId) {
    return roomRef
        .doc(roomDocumentId)
        .collection('users')
        .doc(userDocumentId)
        .update({'inRoom': false});
  }

  static Future<MessageModel> getUsersMessages(uid) async {
    final profile = await userRef.doc(uid).get();
    final String errorMessage = '取得に失敗しました';
    MessageModel myMessages = MessageModel(
      initialMessage: profile.data()?['initialMessage'] ?? errorMessage,
      progressMessage: profile.data()?['progressMessage'] ?? errorMessage,
      lastMessage: profile.data()?['lastMessage'] ?? errorMessage,
      color: profile.data()?['color'] ?? errorMessage,
      imageIndex: profile.data()?['imageIndex'] ?? errorMessage
    );
    return myMessages;
  }

  static Future<void> updateMessages(uid, initialMessage, progressMessage, lastMessage) async {
    return await userRef
        .doc(uid)
        .update({
          'initialMessage': initialMessage,
          'progressMessage': progressMessage,
          'lastMessage': lastMessage,
        });
  }
}