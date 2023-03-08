import 'package:floor/floor.dart';

abstract class BaseDao<T> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItem(T item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItems(List<T> item);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateItem(T item);

  @update
  Future<void> updateItems(List<T> item);
}
