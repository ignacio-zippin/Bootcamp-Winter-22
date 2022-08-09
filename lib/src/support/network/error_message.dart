import 'package:fluttertoast/fluttertoast.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/support/network/network.dart';
import 'package:playground_app/values/k_colors.dart';

onResultErrorDefault(HttpResult error, {Function? onRetry}) {
  switch (error.type) {
    case HttpCodesEnum.e401_Unauthorized:
      return PageManager().goDoLogout();
    case HttpCodesEnum.s204_NoContent:
      return PageManager().openDefaultErrorAlert(
          'Ocurrió un error, por favor intente nuevamente más tarde',
          onRetry: onRetry);
    case HttpCodesEnum.e500_InternalServerError:
      return PageManager().openDefaultErrorAlert(
          'Hubo un problema en el servidor, por favor intente nuevamente más tarde',
          onRetry: onRetry);
    case HttpCodesEnum.NoInternetConnection:
      return PageManager().openDefaultErrorAlert('No hay conexion a internet',
          onRetry: onRetry);
    default:
      return PageManager().openDefaultErrorAlert(
          'Ocurrió un error, por favor intente nuevamente más tarde',
          onRetry: onRetry);
  }
}

onErrorFunction({required HttpResult? error, onRetry}) {
  switch (error!.type) {
    case HttpCodesEnum.e401_Unauthorized:
      return PageManager().goDoLogout();
    case HttpCodesEnum.s204_NoContent:
      return PageManager().openDefaultErrorAlert(
          'Ocurrió un error, por favor intente nuevamente más tarde',
          onRetry: onRetry);
    case HttpCodesEnum.e500_InternalServerError:
      return PageManager().openDefaultErrorAlert(
          'Hubo un problema en el servidor, por favor intente nuevamente más tarde',
          onRetry: onRetry);
    case HttpCodesEnum.NoInternetConnection:
      return PageManager().openDefaultErrorAlert('No hay conexion a internet',
          onRetry: onRetry);
    default:
      return PageManager().openDefaultErrorAlert(
          'Ocurrió un error, por favor intente nuevamente más tarde',
          onRetry: onRetry);
  }
}

msgError(String? msg) {
  Fluttertoast.showToast(
      msg: msg ?? "Error",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: KGrey_L1,
      textColor: KWhite,
      fontSize: 16.0);
}
