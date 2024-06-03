class Resposta {
  static const SUCESS = 1;
  static const ERROR = 2;
  static const FATAL_ERROR = 3;

  late int resultado;
  late Object object;

  Resposta();

  bool isSucess() {
    if (this.resultado == 1) {
      return true;
    }
    return false;
  }

  bool isError() {
    if (this.resultado == 2) {
      return true;
    }
    return false;
  }

  bool isFatalError() {
    if (this.resultado == 3) {
      return true;
    }
    return false;
  }
}
