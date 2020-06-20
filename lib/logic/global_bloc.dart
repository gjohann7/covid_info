import 'dart:async';

import '../models/global.dart';
import '../database/global_db.dart';

class GlobalBloc {
  GlobalDb db;
  List<Global> _globalList;

  final _globalsStreamController = StreamController<List<Global>>.broadcast();
  final _globalRenewController = StreamController<Global>();
  final _globalDeleteAllController = StreamController<bool>();

  Stream<List<Global>> get globals => _globalsStreamController.stream;
  StreamSink<List<Global>> get globalsSink => _globalsStreamController.sink;
  StreamSink<Global> get globalRenewSink => _globalRenewController.sink;
  StreamSink<bool> get globalDeleteAllSink => _globalDeleteAllController.sink;

  GlobalBloc() {
    db = GlobalDb();
    getGlobals();

    _globalsStreamController.stream.listen(returnGlobals);
    _globalRenewController.stream.listen(_renew);
    _globalDeleteAllController.stream.listen(_deleteAll);
  }

  Future getGlobals() async {
    List<Global> globals = await db.getAll();
    _globalList = globals;
    globalsSink.add(globals);
  }

  List<Global> returnGlobals(globals) {
    return globals;
  }

  List<Global> get globalList {
    return _globalList;
  }

  void _renew(Global global) {
    db.insert(global).then((result) {
      getGlobals();
    });
  }

  void _deleteAll(bool confirm) {
    if (confirm) {
      db.deleteAll().then((result) {
        getGlobals();
      });
    }
  }

  void dispose() {
    _globalsStreamController.close();
    _globalRenewController.close();
    _globalDeleteAllController.close();
  }
}
