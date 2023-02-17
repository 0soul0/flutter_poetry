// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FileDao? _fileDaoInstance;

  SystemInfoDao? _systemInfoDaoInstance;

  PoetryDao? _poetryDaoInstance;

  CatalogueDao? _catalogueDaoInstance;

  SubCategoryDao? _subCategoryDaoInstance;

  RecordDao? _recordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FileModel` (`id` TEXT NOT NULL, `fileName` TEXT NOT NULL, `dataVersion` TEXT NOT NULL, `url` TEXT NOT NULL, `updateDate` TEXT NOT NULL, `updates` TEXT NOT NULL, `dbType` TEXT NOT NULL, `dataUpdateDone` INTEGER NOT NULL, `status` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SystemInfoModel` (`id` TEXT NOT NULL, `appVersion` TEXT NOT NULL, `baseUrl` TEXT NOT NULL, `updateContent` TEXT NOT NULL, `status` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PoetryModel` (`id` TEXT NOT NULL, `number` INTEGER NOT NULL, `type` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `refrain` TEXT NOT NULL, `author` TEXT NOT NULL, `category` TEXT NOT NULL, `subCategory` TEXT NOT NULL, `url` TEXT NOT NULL, `pianoSpectrum` TEXT NOT NULL, `guitarSpectrum` TEXT NOT NULL, `pianoMedia` TEXT NOT NULL, `pianoMedia2` TEXT NOT NULL, `singMedia` TEXT NOT NULL, `guitarMedia` TEXT NOT NULL, `description` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CatalogueModel` (`id` TEXT NOT NULL, `category` TEXT NOT NULL, `selectedStatus` TEXT NOT NULL, `type` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SubCategoryModel` (`id` TEXT NOT NULL, `categoryID` TEXT NOT NULL, `subcategory` TEXT NOT NULL, `startVerseNumber` INTEGER NOT NULL, `endVerseNumber` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecordModel` (`sourceId` TEXT NOT NULL, `createTime` TEXT NOT NULL, `id` TEXT NOT NULL, `number` INTEGER NOT NULL, `type` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `refrain` TEXT NOT NULL, `author` TEXT NOT NULL, `category` TEXT NOT NULL, `subCategory` TEXT NOT NULL, `url` TEXT NOT NULL, `pianoSpectrum` TEXT NOT NULL, `guitarSpectrum` TEXT NOT NULL, `pianoMedia` TEXT NOT NULL, `pianoMedia2` TEXT NOT NULL, `singMedia` TEXT NOT NULL, `guitarMedia` TEXT NOT NULL, `description` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FileDao get fileDao {
    return _fileDaoInstance ??= _$FileDao(database, changeListener);
  }

  @override
  SystemInfoDao get systemInfoDao {
    return _systemInfoDaoInstance ??= _$SystemInfoDao(database, changeListener);
  }

  @override
  PoetryDao get poetryDao {
    return _poetryDaoInstance ??= _$PoetryDao(database, changeListener);
  }

  @override
  CatalogueDao get catalogueDao {
    return _catalogueDaoInstance ??= _$CatalogueDao(database, changeListener);
  }

  @override
  SubCategoryDao get subCategoryDao {
    return _subCategoryDaoInstance ??=
        _$SubCategoryDao(database, changeListener);
  }

  @override
  RecordDao get recordDao {
    return _recordDaoInstance ??= _$RecordDao(database, changeListener);
  }
}

class _$FileDao extends FileDao {
  _$FileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fileModelInsertionAdapter = InsertionAdapter(
            database,
            'FileModel',
            (FileModel item) => <String, Object?>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'dataVersion': item.dataVersion,
                  'url': item.url,
                  'updateDate': item.updateDate,
                  'updates': item.updates,
                  'dbType': item.dbType,
                  'dataUpdateDone': item.dataUpdateDone,
                  'status': item.status
                }),
        _fileModelUpdateAdapter = UpdateAdapter(
            database,
            'FileModel',
            ['id'],
            (FileModel item) => <String, Object?>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'dataVersion': item.dataVersion,
                  'url': item.url,
                  'updateDate': item.updateDate,
                  'updates': item.updates,
                  'dbType': item.dbType,
                  'dataUpdateDone': item.dataUpdateDone,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FileModel> _fileModelInsertionAdapter;

  final UpdateAdapter<FileModel> _fileModelUpdateAdapter;

  @override
  Future<List<FileModel>> queryAll() async {
    return _queryAdapter.queryList('SELECT * FROM FileModel',
        mapper: (Map<String, Object?> row) => FileModel(
            id: row['id'] as String,
            fileName: row['fileName'] as String,
            dataVersion: row['dataVersion'] as String,
            url: row['url'] as String,
            updateDate: row['updateDate'] as String,
            updates: row['updates'] as String,
            dbType: row['dbType'] as String,
            dataUpdateDone: row['dataUpdateDone'] as int));
  }

  @override
  Future<FileModel?> findFileById(String id) async {
    return _queryAdapter.query('SELECT * FROM FileModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FileModel(
            id: row['id'] as String,
            fileName: row['fileName'] as String,
            dataVersion: row['dataVersion'] as String,
            url: row['url'] as String,
            updateDate: row['updateDate'] as String,
            updates: row['updates'] as String,
            dbType: row['dbType'] as String,
            dataUpdateDone: row['dataUpdateDone'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertItem(FileModel item) async {
    await _fileModelInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<FileModel> item) async {
    await _fileModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(FileModel item) async {
    await _fileModelUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<FileModel> item) async {
    await _fileModelUpdateAdapter.updateList(item, OnConflictStrategy.abort);
  }
}

class _$SystemInfoDao extends SystemInfoDao {
  _$SystemInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _systemInfoModelInsertionAdapter = InsertionAdapter(
            database,
            'SystemInfoModel',
            (SystemInfoModel item) => <String, Object?>{
                  'id': item.id,
                  'appVersion': item.appVersion,
                  'baseUrl': item.baseUrl,
                  'updateContent': item.updateContent,
                  'status': item.status
                }),
        _systemInfoModelUpdateAdapter = UpdateAdapter(
            database,
            'SystemInfoModel',
            ['id'],
            (SystemInfoModel item) => <String, Object?>{
                  'id': item.id,
                  'appVersion': item.appVersion,
                  'baseUrl': item.baseUrl,
                  'updateContent': item.updateContent,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SystemInfoModel> _systemInfoModelInsertionAdapter;

  final UpdateAdapter<SystemInfoModel> _systemInfoModelUpdateAdapter;

  @override
  Future<List<SystemInfoModel>> queryAll() async {
    return _queryAdapter.queryList('SELECT * FROM SystemInfoModel',
        mapper: (Map<String, Object?> row) => SystemInfoModel(
            row['status'] as String?,
            id: row['id'] as String,
            appVersion: row['appVersion'] as String,
            baseUrl: row['baseUrl'] as String,
            updateContent: row['updateContent'] as String));
  }

  @override
  Future<SystemInfoModel?> findFileById(String id) async {
    return _queryAdapter.query('SELECT * FROM SystemInfoModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SystemInfoModel(
            row['status'] as String?,
            id: row['id'] as String,
            appVersion: row['appVersion'] as String,
            baseUrl: row['baseUrl'] as String,
            updateContent: row['updateContent'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertItem(SystemInfoModel item) async {
    await _systemInfoModelInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<SystemInfoModel> item) async {
    await _systemInfoModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(SystemInfoModel item) async {
    await _systemInfoModelUpdateAdapter.update(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<SystemInfoModel> item) async {
    await _systemInfoModelUpdateAdapter.updateList(
        item, OnConflictStrategy.abort);
  }
}

class _$PoetryDao extends PoetryDao {
  _$PoetryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _poetryModelInsertionAdapter = InsertionAdapter(
            database,
            'PoetryModel',
            (PoetryModel item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'type': item.type,
                  'title': item.title,
                  'content': item.content,
                  'refrain': item.refrain,
                  'author': item.author,
                  'category': item.category,
                  'subCategory': item.subCategory,
                  'url': item.url,
                  'pianoSpectrum': item.pianoSpectrum,
                  'guitarSpectrum': item.guitarSpectrum,
                  'pianoMedia': item.pianoMedia,
                  'pianoMedia2': item.pianoMedia2,
                  'singMedia': item.singMedia,
                  'guitarMedia': item.guitarMedia,
                  'description': item.description
                }),
        _poetryModelUpdateAdapter = UpdateAdapter(
            database,
            'PoetryModel',
            ['id'],
            (PoetryModel item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'type': item.type,
                  'title': item.title,
                  'content': item.content,
                  'refrain': item.refrain,
                  'author': item.author,
                  'category': item.category,
                  'subCategory': item.subCategory,
                  'url': item.url,
                  'pianoSpectrum': item.pianoSpectrum,
                  'guitarSpectrum': item.guitarSpectrum,
                  'pianoMedia': item.pianoMedia,
                  'pianoMedia2': item.pianoMedia2,
                  'singMedia': item.singMedia,
                  'guitarMedia': item.guitarMedia,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PoetryModel> _poetryModelInsertionAdapter;

  final UpdateAdapter<PoetryModel> _poetryModelUpdateAdapter;

  @override
  Future<List<PoetryModel>> queryAll() async {
    return _queryAdapter.queryList('SELECT * FROM PoetryModel',
        mapper: (Map<String, Object?> row) => PoetryModel(
            id: row['id'] as String,
            number: row['number'] as int,
            type: row['type'] as int,
            title: row['title'] as String,
            content: row['content'] as String,
            refrain: row['refrain'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            subCategory: row['subCategory'] as String,
            url: row['url'] as String,
            pianoSpectrum: row['pianoSpectrum'] as String,
            guitarSpectrum: row['guitarSpectrum'] as String,
            pianoMedia: row['pianoMedia'] as String,
            pianoMedia2: row['pianoMedia2'] as String,
            singMedia: row['singMedia'] as String,
            guitarMedia: row['guitarMedia'] as String,
            description: row['description'] as String));
  }

  @override
  Future<PoetryModel?> query(String id) async {
    return _queryAdapter.query('SELECT * FROM PoetryModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PoetryModel(
            id: row['id'] as String,
            number: row['number'] as int,
            type: row['type'] as int,
            title: row['title'] as String,
            content: row['content'] as String,
            refrain: row['refrain'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            subCategory: row['subCategory'] as String,
            url: row['url'] as String,
            pianoSpectrum: row['pianoSpectrum'] as String,
            guitarSpectrum: row['guitarSpectrum'] as String,
            pianoMedia: row['pianoMedia'] as String,
            pianoMedia2: row['pianoMedia2'] as String,
            singMedia: row['singMedia'] as String,
            guitarMedia: row['guitarMedia'] as String,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<List<PoetryModel>> search(String str) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PoetryModel WHERE number LIKE ?1 OR title LIKE ?1 OR content LIKE ?1 OR refrain LIKE ?1 OR author LIKE ?1 OR category LIKE ?1 OR subCategory LIKE ?1 ORDER BY type ASC, number ASC',
        mapper: (Map<String, Object?> row) => PoetryModel(id: row['id'] as String, number: row['number'] as int, type: row['type'] as int, title: row['title'] as String, content: row['content'] as String, refrain: row['refrain'] as String, author: row['author'] as String, category: row['category'] as String, subCategory: row['subCategory'] as String, url: row['url'] as String, pianoSpectrum: row['pianoSpectrum'] as String, guitarSpectrum: row['guitarSpectrum'] as String, pianoMedia: row['pianoMedia'] as String, pianoMedia2: row['pianoMedia2'] as String, singMedia: row['singMedia'] as String, guitarMedia: row['guitarMedia'] as String, description: row['description'] as String),
        arguments: [str]);
  }

  @override
  Future<void> insertItem(PoetryModel item) async {
    await _poetryModelInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<PoetryModel> item) async {
    await _poetryModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(PoetryModel item) async {
    await _poetryModelUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<PoetryModel> item) async {
    await _poetryModelUpdateAdapter.updateList(item, OnConflictStrategy.abort);
  }
}

class _$CatalogueDao extends CatalogueDao {
  _$CatalogueDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _catalogueModelInsertionAdapter = InsertionAdapter(
            database,
            'CatalogueModel',
            (CatalogueModel item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'selectedStatus': item.selectedStatus,
                  'type': item.type
                }),
        _catalogueModelUpdateAdapter = UpdateAdapter(
            database,
            'CatalogueModel',
            ['id'],
            (CatalogueModel item) => <String, Object?>{
                  'id': item.id,
                  'category': item.category,
                  'selectedStatus': item.selectedStatus,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CatalogueModel> _catalogueModelInsertionAdapter;

  final UpdateAdapter<CatalogueModel> _catalogueModelUpdateAdapter;

  @override
  Future<List<CatalogueModel>> queryAll() async {
    return _queryAdapter.queryList('SELECT * FROM CatalogueModel',
        mapper: (Map<String, Object?> row) => CatalogueModel(
            id: row['id'] as String,
            category: row['category'] as String,
            selectedStatus: row['selectedStatus'] as String,
            type: row['type'] as int));
  }

  @override
  Future<void> insertItem(CatalogueModel item) async {
    await _catalogueModelInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<CatalogueModel> item) async {
    await _catalogueModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(CatalogueModel item) async {
    await _catalogueModelUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<CatalogueModel> item) async {
    await _catalogueModelUpdateAdapter.updateList(
        item, OnConflictStrategy.abort);
  }
}

class _$SubCategoryDao extends SubCategoryDao {
  _$SubCategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subCategoryModelInsertionAdapter = InsertionAdapter(
            database,
            'SubCategoryModel',
            (SubCategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'categoryID': item.categoryID,
                  'subcategory': item.subcategory,
                  'startVerseNumber': item.startVerseNumber,
                  'endVerseNumber': item.endVerseNumber
                }),
        _subCategoryModelUpdateAdapter = UpdateAdapter(
            database,
            'SubCategoryModel',
            ['id'],
            (SubCategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'categoryID': item.categoryID,
                  'subcategory': item.subcategory,
                  'startVerseNumber': item.startVerseNumber,
                  'endVerseNumber': item.endVerseNumber
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubCategoryModel> _subCategoryModelInsertionAdapter;

  final UpdateAdapter<SubCategoryModel> _subCategoryModelUpdateAdapter;

  @override
  Future<List<SubCategoryModel>> queryAll() async {
    return _queryAdapter.queryList('SELECT * FROM SubCategoryModel',
        mapper: (Map<String, Object?> row) => SubCategoryModel(
            id: row['id'] as String,
            categoryID: row['categoryID'] as String,
            subcategory: row['subcategory'] as String,
            startVerseNumber: row['startVerseNumber'] as int,
            endVerseNumber: row['endVerseNumber'] as int));
  }

  @override
  Future<void> insertItem(SubCategoryModel item) async {
    await _subCategoryModelInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<SubCategoryModel> item) async {
    await _subCategoryModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(SubCategoryModel item) async {
    await _subCategoryModelUpdateAdapter.update(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<SubCategoryModel> item) async {
    await _subCategoryModelUpdateAdapter.updateList(
        item, OnConflictStrategy.abort);
  }
}

class _$RecordDao extends RecordDao {
  _$RecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recordModelInsertionAdapter = InsertionAdapter(
            database,
            'RecordModel',
            (RecordModel item) => <String, Object?>{
                  'sourceId': item.sourceId,
                  'createTime': item.createTime,
                  'id': item.id,
                  'number': item.number,
                  'type': item.type,
                  'title': item.title,
                  'content': item.content,
                  'refrain': item.refrain,
                  'author': item.author,
                  'category': item.category,
                  'subCategory': item.subCategory,
                  'url': item.url,
                  'pianoSpectrum': item.pianoSpectrum,
                  'guitarSpectrum': item.guitarSpectrum,
                  'pianoMedia': item.pianoMedia,
                  'pianoMedia2': item.pianoMedia2,
                  'singMedia': item.singMedia,
                  'guitarMedia': item.guitarMedia,
                  'description': item.description
                }),
        _recordModelUpdateAdapter = UpdateAdapter(
            database,
            'RecordModel',
            ['id'],
            (RecordModel item) => <String, Object?>{
                  'sourceId': item.sourceId,
                  'createTime': item.createTime,
                  'id': item.id,
                  'number': item.number,
                  'type': item.type,
                  'title': item.title,
                  'content': item.content,
                  'refrain': item.refrain,
                  'author': item.author,
                  'category': item.category,
                  'subCategory': item.subCategory,
                  'url': item.url,
                  'pianoSpectrum': item.pianoSpectrum,
                  'guitarSpectrum': item.guitarSpectrum,
                  'pianoMedia': item.pianoMedia,
                  'pianoMedia2': item.pianoMedia2,
                  'singMedia': item.singMedia,
                  'guitarMedia': item.guitarMedia,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecordModel> _recordModelInsertionAdapter;

  final UpdateAdapter<RecordModel> _recordModelUpdateAdapter;

  @override
  Future<List<RecordModel>> queryPage(
    int page,
    int count,
    String orderBy,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RecordModel ORDER BY ?3 LIMIT ?1,?2',
        mapper: (Map<String, Object?> row) => RecordModel(
            row['sourceId'] as String,
            id: row['id'] as String,
            title: row['title'] as String,
            number: row['number'] as int,
            description: row['description'] as String),
        arguments: [page, count, orderBy]);
  }

  @override
  Future<RecordModel?> queryBySourceId(String sourceId) async {
    return _queryAdapter.query('SELECT * FROM RecordModel WHERE sourceId = ?1',
        mapper: (Map<String, Object?> row) => RecordModel(
            row['sourceId'] as String,
            id: row['id'] as String,
            title: row['title'] as String,
            number: row['number'] as int,
            description: row['description'] as String),
        arguments: [sourceId]);
  }

  @override
  Future<void> insertItem(RecordModel item) async {
    await _recordModelInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<RecordModel> item) async {
    await _recordModelInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(RecordModel item) async {
    await _recordModelUpdateAdapter.update(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItems(List<RecordModel> item) async {
    await _recordModelUpdateAdapter.updateList(item, OnConflictStrategy.abort);
  }
}
