library object_manager;

import "dart:mirrors";

import "entries.dart";


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


class StandardObjectManager extends AbstractObjectManager {
  static final StandardObjectManager instance = new StandardObjectManager();

  static final Map<String, ClassMirror> classMirrors
      = new Map<String, ClassMirror>();

  void registerClasses() {
    currentMirrorSystem().libraries.forEach((uri, libraryMirror) {
      if(!libraryMirror.simpleName.toString().contains("dart.")) {
        libraryMirror.declarations.forEach((symbol, mirror) {
          if(mirror is ClassMirror) {
            String name = mirror.simpleName.toString();
            classMirrors[name.substring(8,name.length - 2)] = mirror;
          }
        });
      }
    });
  }

  static int maxIndex = 0;

  final Map<String, int> objectIndex = new Map<String, int>();
  final Map<Serializable, ObjectEntry> objectEntries
      = new Map<Serializable, ObjectEntry>();
  ObjectEntry _currentObjectEntry;

  bool loading;

  int intEntry(String id, int value) {
    if(loading) {
      return _currentObjectEntry[id].intValue;
    } else {
      _currentObjectEntry[id] = new IntEntry(value);
      return value;
    }
  }

  double doubleEntry(String id, double value) {
    if(loading) {
      return _currentObjectEntry[id].doubleValue;
    } else {
      _currentObjectEntry[id] = new DoubleEntry(value);
      return value;
    }
  }

  String stringEntry(String id, String value) {
    if(loading) {
      return _currentObjectEntry[id].stringValue;
    } else {
      _currentObjectEntry[id] = new StringEntry(value);
      return value;
    }
  }

  Serializable objectEntry(String id, Serializable value) {
    if(loading) {
      return objectFromEntry(_currentObjectEntry[id]);
    } else {
      _currentObjectEntry[id] = entryFromObject(value);
      return value;
    }
  }

  List<Serializable> listEntry(String id, List<Serializable> value) {
    if(loading) {
      return _currentObjectEntry[id].listValue;
    } else {
      List<Entry> entriesList = new List<Entry>();
      for(Serializable object in value) {
        entriesList.add(entryFromObject(object));
      }
      _currentObjectEntry[id] = new ListEntry(entriesList);
      return value;
    }
  }


  ObjectEntry entryFromObject(Serializable object) {
    loading = false;
    ObjectEntry objectEntry = objectEntries[object];
    if(objectEntry == null){
      objectEntry = new ObjectEntry(object.runtimeType.toString());
      objectEntries[object] = objectEntry;

      ObjectEntry oldObjectEntry = _currentObjectEntry;
      _currentObjectEntry = objectEntry;
      object.manage(this);
      _currentObjectEntry = oldObjectEntry;

      objectEntry.index = 0;
    } else {
      maxIndex++;
      objectEntry.index = maxIndex;
    }

    return objectEntry;
  }


  Serializable objectFromEntry(ObjectEntry entry) {
    loading = true;
    Serializable entryObject = entry.objectValue;
    if(entryObject == null){
      if(classMirrors.isEmpty) registerClasses();
      entryObject = classMirrors[entry.className]
          .newInstance(const Symbol("loader"), []).reflectee;
      entry.objectValue = entryObject;

      ObjectEntry oldObjectEntry = _currentObjectEntry;
      _currentObjectEntry = entry;
      entryObject.manage(this);
      _currentObjectEntry = oldObjectEntry;
    }
    return entryObject;
  }
}