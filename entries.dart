library entries;

import "object_manager.dart";
import "entry_manager.dart";


abstract class Entry {
    int get intValue => 0;
    double get doubleValue => 0.0;
    String get stringValue => "";
    Serializable get objectValue => null;
    List<Serializable> get listValue => null;

    void store(AbstractEntryManager manager);
}


// Object entries


class IntEntry extends Entry {
  int _value;

  IntEntry(this._value);

  int get intValue => _value;
  double get doubleValue => _value.toDouble();
  String get stringValue => _value.toString();

  void store(AbstractEntryManager manager) {
    manager.storeInt(_value);
  }
}


class DoubleEntry extends Entry {
  double _value;

  DoubleEntry(this._value);

  int get intValue => _value.toInt();
  double get doubleValue => _value;
  String get stringValue => _value.toString();

  void store(AbstractEntryManager manager) {
    manager.storeDouble(_value);
  }
}


class StringEntry extends Entry {
  String _value;

  StringEntry(this._value);

  int get intValue => int.parse(_value);
  double get doubleValue => double.parse(_value);
  String get stringValue => _value;

  void store(AbstractEntryManager manager) {
    manager.storeString(_value);
  }
}


class ObjectEntry extends Entry {
  final Map<String, Entry> entries = new Map<String, Entry>();
  String className;
  Serializable _value;
  int index = -1;

  ObjectEntry(this.className);

  Entry operator [](String id) => entries[id];
  operator []=(String id, Entry value) => entries[id] = value;

  Serializable get objectValue => _value;
  set objectValue(Serializable value) {_value = value;}

  void store(AbstractEntryManager manager) {
    manager.storeObject(this);
  }
}


// List entries

/*class IntListEntry extends Entry {
  List<int> _entries;

  IntListEntry(this._entries);

  int operator [](int index) => _entries[index];
  operator []=(int index, int value) => _entries[index] = value;
}


class DoubleListEntry extends Entry {
  List<double> _entries;

  DoubleListEntry(this._entries);

  double operator [](int index) => _entries[index];
  operator []=(int index, double value) => _entries[index] = value;
}


class StringListEntry extends Entry {
  List<String> _entries = new List<String>();

  StringListEntry(this._entries);

  String operator [](int index) => _entries[index];
  operator []=(int index, String value) => _entries[index] = value;
}*/


class ListEntry extends Entry {
  List<Entry> _entries = new List<Entry>();

  ListEntry(this._entries);

  Entry operator [](int index) => _entries[index];
  operator []=(int index, Entry value) => _entries[index] = value;

  Entry entriesType;

  void store(AbstractEntryManager manager) {
    manager.storeList(_entries);
  }
}