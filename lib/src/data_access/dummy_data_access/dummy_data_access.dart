import 'dart:io';
import 'package:playground_app/src/exceptions/exception_launcher.dart';
import 'package:playground_app/src/interfaces/i_data_access.dart';

class DummyDataAccess implements IDataAccess {
  // Add this function in every dummy function for exception testing
  // ignore: unused_element
  _verifyExceptionThrow() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      // print(StackTrace.current.toString());
      ExceptionLauncher().explode();
    }
  }

  @override
  late String token;
}
