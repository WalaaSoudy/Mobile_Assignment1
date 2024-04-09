import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_5/UserModel.dart';

class DbHelper {
  static Database? _db;

  static const String DB_NAME = 'test.db';
  static const String TABLE_USERS = 'users';

  static const String COLUMN_NAME = 'name';
  static const String COLUMN_GENDER = 'gender';
  static const String COLUMN_EMAIL = 'email';
  static const String COLUMN_STUDENT_ID = 'student_id';
  static const String COLUMN_LEVEL = 'level';
  static const String COLUMN_PASSWORD = 'password';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

 Future<Database> initDb() async {
  final String path = join(await getDatabasesPath(), DB_NAME);
  return openDatabase(path, version: 2, onCreate: _createDb, onUpgrade: _onUpgrade);
}

void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Check if the column already exists
    var existingColumns = await db.rawQuery('PRAGMA table_info($TABLE_USERS)');
    bool columnExists = existingColumns.any((column) => column['name'] == COLUMN_IMAGE_PATH);

    // Add the image_path column only if it doesn't exist
    if (!columnExists) {
      await db.execute('ALTER TABLE $TABLE_USERS ADD COLUMN $COLUMN_IMAGE_PATH TEXT');
    }
  }
}


  static const String COLUMN_IMAGE_PATH = 'image_path'; // Add this constant for the column name
Future<void> updateUser(UserModel user) async {
  final db = await this.db;
  await db!.update(
    TABLE_USERS,
    user.toMap(),
    where: '$COLUMN_STUDENT_ID = ?',
    whereArgs: [user.studentID],
  );
}

void _createDb(Database db, int version) async {
  await db.execute('''
    CREATE TABLE $TABLE_USERS (
      $COLUMN_NAME TEXT,
      $COLUMN_GENDER TEXT,
      $COLUMN_EMAIL TEXT,
      $COLUMN_STUDENT_ID TEXT PRIMARY KEY,
      $COLUMN_LEVEL INTEGER,
      $COLUMN_PASSWORD TEXT,
      $COLUMN_IMAGE_PATH TEXT // Add the column for storing the image path
    )
  ''');
}
 Future<void> saveImage(String userId, String imagePath) async {
    final db = await this.db;
    await db!.update(
      TABLE_USERS,
      {COLUMN_IMAGE_PATH: imagePath},
      where: '$COLUMN_STUDENT_ID = ?',
      whereArgs: [userId],
    );
  }
  // Future<void> saveImage(String userId, String imagePath) async {
  //   await _db.update(
  //     'users',
  //     {'image': imagePath},
  //     where: 'id = ?',
  //     whereArgs: [userId],
  //   );
  // }
Future<UserModel?> getUserById(String userId) async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(
      TABLE_USERS,
      where: '$COLUMN_STUDENT_ID = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }
  Future<int> insertUser(UserModel user) async {
    final db = await this.db;
    return db!.insert(TABLE_USERS, user.toMap());
  }
  Future<UserModel?> getUser(String studentID, String password) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_USERS,
      where: '$COLUMN_STUDENT_ID = ? AND $COLUMN_PASSWORD = ?',
      whereArgs: [studentID, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}
