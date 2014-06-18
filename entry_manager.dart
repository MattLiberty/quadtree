//import "object_manager.dart";
import "entries.dart";
import "symbols.dart";


abstract class AbstractEntryManager {
  void storeInt(int value);
  void storeDouble(double value);
  void storeString(String value);
  void storeObject(ObjectEntry entry);
  void storeList(List<Entry> entries);
}


class TextEntryManager extends AbstractEntryManager {
  static TextEntryManager instance = new TextEntryManager();

  String _text;
  String _tabs;

  static encodeString(String string) => "\"" + string
      .replaceAll("\"", "\\\"")
      .replaceAll("\\", "\\\\") + "\"";

  String entryToText(ObjectEntry objectEntry) {
    _text = "";
    _tabs = "";
    objectEntry.store(this);
    return _text;
  }

  void storeInt(int value) {
    _text += value.toString();
  }

  void storeDouble(double value) {
    _text += value.toString();
  }

  void storeString(String value) {
    _text += "\"" + value + "\"";
  }

  /*void transformIntList(List<int> entries) {
    _text = "";
    entries.forEach((int value) {
      _text += "," + value.toString();
    });
    _text = "[" + _text.substring(1) + "]";
  }

  void transformDoubleList(List<double> entries) {
    _text = "";
    entries.forEach((double value) {
      _text += "," + value.toString();
    });
    _text = "[" + _text.substring(1) + "]";
  }

  void transformStringList(List<String> entries) {
    _text = "";
    entries.forEach((String value) {
      _text += "," + value;
    });
    _text = "[" + _text.substring(1) + "]";
  }*/

  void storeList(List<Entry> entries) {
    _text += "[";
    _tabs += "\t";
    bool first = true;
    entries.forEach((entry) {
      if(!first) _text += ",";
      _text += "\r\n" + _tabs;
      entry.store(this);
      first = false;
    });
    _tabs = _tabs.substring(1);
    _text += "]";
  }

  void storeObject(ObjectEntry entry) {
    _text += entry.className;
    Map<String, Entry> entries = entry.entries;
    if(entry.index > 0) {
      _text += "-" + entry.index.toString();
    } else if(entries.length == 1 && entries.containsKey("")) {
      Entry childEntry = entries[""];
      if(childEntry is ListEntry) {
        childEntry.store(this);
      } else {
        _text += "(";
        childEntry.store(this);
        _text += ")";
      }
    } else {
      _text += "{";
      _tabs += "\t";
      bool first = true;
      entries.forEach((identifier, entry) {
        if(!first) _text += ",";
        _text += "\r\n" + _tabs + identifier + ":";
        entry.store(this);
        first = false;
      });
      _tabs = _tabs.substring(1);
      _text += "}";
    }
  }


  int pos;
  Entry textToEntry(String text) {
    _text = text;
    pos = -1;
    return readEntry();
  }

  bool endOfList;
  Entry readEntry() {
    String string = "";
    bool isDouble = false;
    int parsingString = 0;
    while(true){
      pos++;
      int symbol = _text.codeUnitAt(pos);
      if(symbol == quotesCode) {
        parsingString++;
      } else if(parsingString == 1) {
        string += _text[pos];
      } else {
        switch(symbol) {
          case spaceCode:
          case tabCode:
          case nCode:
          case rCode:
            break;
          case leftRoundBracketCode:
            ObjectEntry entry = new ObjectEntry(string);
            entry[""] = readEntry();
            return entry;
          case leftSquareBracketCode:
            if(string.isEmpty) return readList();
            print("list: $string");
            ObjectEntry entry = new ObjectEntry(string);
            entry[""] = readList();
            return entry;
          case leftCurlyBracketCode:
            print("object: $string");
            return readDictionary(string);
          case commaCode:
          case colonCode:
          case rightRoundBracketCode:
          case rightSquareBracketCode:
          case rightCurlyBracketCode:
            if(symbol == rightSquareBracketCode ||
                symbol == rightCurlyBracketCode) {
              print("bracket");
              endOfList = true;
            }
            if(string.isEmpty) {
              return null;
            } else if(parsingString > 0) {
              print("string:$string");
              return new StringEntry(string);
            } else if(isDigit(string.codeUnitAt(0))) {
              print("number:$string");
              if(isDouble) {
                return new DoubleEntry(double.parse(string));
              } else {
                return new IntEntry(int.parse(string));
              }
            }
            print("identifier:$string");
            return new StringEntry(string);
          default:
            if(symbol == dotCode) isDouble = true;
            string += _text[pos];
            break;
        }
      }
    }
  }

  ListEntry readList() {
    List<Entry> list = new List<Entry>();
    endOfList = false;
    while(!endOfList) {
      Entry entry = readEntry();
      if(entry != null) list.add(entry);
    }
    print("end of list");
    endOfList = false;
    return new ListEntry(list);
  }

  ObjectEntry readDictionary(String className) {
    ObjectEntry entry = new ObjectEntry(className);
    endOfList = false;
    while(!endOfList) {
      Entry idEntry = readEntry();
      if(idEntry == null) continue;
      String identifier = idEntry.stringValue;
      entry[identifier] = readEntry();
    }
    print("end of object");
    endOfList = false;
    return entry;
  }
}