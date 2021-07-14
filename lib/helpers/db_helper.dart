// import 'dart:io';
// import 'package:path/path.dart' as path;
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';

// class DBHelper {
//   static Future<Database> database() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String dbPath = path.join(
//       documentsDirectory.path,
//       "covid_db.sqlite",
//     );

//     if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
//       ByteData data = await rootBundle.load(
//         path.join(
//           'assets/databases',
//           'covid_db.sqlite',
//         ),
//       );
//       List<int> bytes = data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );
//       await new File(dbPath).writeAsBytes(bytes);
//     }
//     return sql.openDatabase(
//       path.join(dbPath),
//       onCreate: (db, version) => print('Done'),
//       version: 1,
//     );
//   }

//   static Future<List<Map<String, dynamic>>> getData(String table) async {
//     final db = await DBHelper.database();
//     return db.query(table);
//   }
// }
