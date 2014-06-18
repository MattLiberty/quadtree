library object_manager;


abstract class Serializable {
  void manage(AbstractObjectManager manager);
}


abstract class AbstractObjectManager {
  int intEntry(String id, int value);
  double doubleEntry(String id, double value);
  String stringEntry(String id, String value);
  Serializable objectEntry(String id, Serializable value);
  List<Serializable> listEntry(String id, List<Serializable> value);
}