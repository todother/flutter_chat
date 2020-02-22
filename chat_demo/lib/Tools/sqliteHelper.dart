import 'package:chat_demo/Model/userLoginModel.dart';
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
      return database.execute(
        '''
        create table tbl_curlogin(
          loginId TEXT PRIMARY KEY,
          loginDate DATETIME NOT NULL,
          imei TEXT NOT NULL
        );
        
      ''',
      );
    }, version: 2);
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

  updateLastLoginDate() async {
    UserLoginModel loginModel = await findCurLoginRecord();

    if (loginModel.loginId != "" && loginModel.loginId != null) {
      await initDB();
      loginModel.loginDate = DateTime.now();
      await _db.update("tbl_curlogin", loginModel.toJson());
      await _db.close();
    }
  }
}
