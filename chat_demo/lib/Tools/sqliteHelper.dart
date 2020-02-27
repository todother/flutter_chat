import 'package:chat_demo/Model/chatModel.dart';
import 'package:chat_demo/Model/sqliteModel/tchatlog.dart';
import 'package:chat_demo/Model/sqliteModel/tuser.dart';
import 'package:chat_demo/Model/userLoginModel.dart';
import 'package:chat_demo/Tools/dioHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class SqliteHelper {
  String _dbDir;
  String _dbName = "chatDemo.db";
  Database _db;
  initDB() async {
    _dbDir = await getDatabasesPath();
    _db = await openDatabase(p.join(_dbDir, _dbName),
        onCreate: (database, version) {
      // version1
      

      

      // create table tbl_chatlog(
      //     chatId TEXT PRIMARY KEY,
      //     loginId TEXT ,
      //     contentType INTEGER ,
      //     toUser TEXT,
      //     otherId TEXT,
      //     content TEXT,
      //     fromUser TEXT,
      //     grpId TEXT,
      //     imgPath TEXT,
      //     insertTime DATETIME,
      //     videoPath TEXT,
      //     voiceLength INTEGER,
      //     voicePath TEXT);
      //alter table tbl_chatLog add column locaddress TEXT;
      var batch=database.batch();
      batch.execute('''
      create table tbl_curlogin(
        loginId TEXT PRIMARY KEY,
        loginDate DATETIME NOT NULL,
        imei TEXT NOT NULL
      );''');

      batch.execute('''
        create table tbl_user(
          userId TEXT PRIMARY KEY,
          userName TEXT NOT NULL,
          avatar TEXT NOT NULL
        );
      ''');

      batch.execute('''
        create table tbl_chatlog(
          chatId TEXT PRIMARY KEY,
          loginId TEXT ,
          contentType INTEGER,
          toUser TEXT,
          content TEXT,
          fromUser TEXT,
          grpId TEXT,
          imgPath TEXT,
          insertTime DATETIME,
          videoPath TEXT,
          voiceLength INTEGER ,
          voicePath TEXT,
          locaddress TEXT,
          imgWidth NUMERIC,
          imgHeight NUMERIC,
          title TEXT,
          locationImg TEXT,
          otherId TEXT
        )
      ''');
      batch.commit();
    }, onUpgrade: (database, v1, v2) {
      print('old v is $v1, new version is $v2');
      var batch = database.batch();
      // batch.execute('''
        
      //   alter table tbl_chatLog add column imgHeight NUMERIC;
        
        
      // ''');
      batch.execute("alter table tbl_chatLog add column imgWidth NUMERIC;");
      batch.execute("alter table tbl_chatLog add column imgHeight NUMERIC");
      batch.execute("alter table tbl_chatLog add column title TEXT;");
      batch.execute("alter table tbl_chatLog add column locationImg TEXT;");
      batch.commit();

    }, version: 22);
  }

  addNewLogin(String loginId, String imei) async {
    await initDB();
    UserLoginModel loginModel =
        UserLoginModel(imei: imei, loginDate: DateTime.now(), loginId: loginId);
    await _db.insert("tbl_curlogin", loginModel.toJson());
    await _db.close();
  }

  Future<UserLoginModel> findCurLoginRecord() async {
    await initDB();
    UserLoginModel loginModel = UserLoginModel();
    List<Map<String, dynamic>> results = await _db.query("tbl_curlogin");
    if (results.length > 0) {
      loginModel = UserLoginModel.fromJson(results.first);
    } else {}
    await _db.close();
    return loginModel;
  }

  delCurLoginRecord() async {
    await initDB();
    await _db.delete("tbl_curlogin");
    await _db.close();
  }

  getUserInfo(String userId) async {
    await initDB();
    Tuser userModel;
    var user =
        await _db.query('tbl_user', where: "userId=?", whereArgs: [userId]);
    if (user.length > 0) {
      userModel = Tuser.fromJson(user.first);
    } else {
      userModel = await addNewUser(userId);
    }
    return userModel;
  }

  insertChatRecord(TChatLog chatLog, String loginId) async {
    await initDB();
    String otherId = "";
    if (chatLog.fromUser == loginId) {
      otherId = chatLog.toUser;
    } else {
      otherId = chatLog.fromUser;
    }
    //find if have chat instance
    // var prevChat =await _db.query('tbl_chatlog',
    //     where: "loginId=? ",
    //     whereArgs: [loginId]);
    // if(prevChat.length>0){
    //   instanceId=TChatLog.fromJson( prevChat.first).
    // }
    chatLog.loginId = loginId;
    chatLog.otherId = otherId;
    chatLog.insertTime = DateTime.now();
    await _db.insert('tbl_chatlog', chatLog.toJson());
    await _db.close();
  }

  getLatestChatLogForEachInstance(String loginId) async {
    await initDB();
    List<TChatLog> chats = List<TChatLog>();
    var result = await _db.rawQuery('''
    select tchat.insertTime,tchat.content,tchat.contentType,tchat.otherId
    from (
      select max(insertTime) as lastTime,loginId,otherId
      from tbl_chatlog where loginId=? group by loginId,otherId) tchatlast
    left join tbl_chatlog tchat on 
    tchatlast.loginId=tchat.loginId 
    and tchatlast.otherId=tchat.otherId
    and tchat.insertTime = tchatlast.lastTime where grpId is null 
    order by tchatlast.lastTime desc;
    ''', [loginId]);

    if (result.length > 0) {
      // result.forEach((item) async {});
      int i = 0;
      for (i = 0; i < result.length; i++) {
        TChatLog chatLog = TChatLog.fromJson(result[i]);
        await addNewUser(chatLog.otherId);
        chats.add(chatLog);
      }
    }
    _db.close();
    return chats;
  }

  getChatRecordsByUserId(String loginId, String otherId, int offset) async {
    await initDB();
    int eachPage = 30;
    // int from = pageId * eachPage;
    // int to = from + eachPage - 1;
    List<ChatModel> chatModels = List<ChatModel>();
    var chats = await _db.query('tbl_chatLog',
        where: 'loginId=? and otherId=?',
        whereArgs: [loginId, otherId],
        orderBy: 'insertTime desc',
        limit: eachPage,
        offset: offset);
    int i=0;
    for(i=0;i<chats.length;i++){
      ChatModel model=ChatModel();
      model.contentModel=TChatLog.fromJson(chats[i]);
      Tuser user=await addNewUser(model.contentModel.fromUser);
      model.user=user;
      chatModels.add(model);
    }
    return chatModels;
  }

  addNewUser(String userId) async {
    await initDB();
    Tuser userModel;
    var userRecord =
        await _db.query('tbl_user', where: "userId=?", whereArgs: [userId]);
    if (userRecord.length > 0) {
      //have userRecord
      userModel = Tuser.fromJson(userRecord.first);
    } else {
      var dio = DioHelper().dio;
      var user = await dio
          .get("/user/getUserInfo", queryParameters: {"userId": userId});
      userModel = Tuser.fromJson(user.data);
      await _db.insert('tbl_user', userModel.toJson());
    }
    await _db.close();
    return userModel;
  }

  getChatList(String loginId) async {
    await initDB();
    var result = _db.execute("");
  }

  updateLastLoginDate() async {
    UserLoginModel loginModel = await findCurLoginRecord();

    if (loginModel.loginId != "" && loginModel.loginId != null) {
      await initDB();
      loginModel.loginDate = DateTime.now();
      await _db.update("tbl_curlogin", loginModel.toJson());
      await _db.close();
    }
  }


  getAllUsers()async{
    await initDB();
    List<Tuser> users=List<Tuser>();
    var result=await _db.query('tbl_user');
    result.forEach((item){
      Tuser user=Tuser.fromJson(item);
      users.add(user);
    });
    return users;
  }

  
}
