import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
    bool isStart = false;
    bool isQuit = false;
    bool isReplay = false;
    bool isLoading = false;

    void init() {
      isStart = false;
      isQuit = false;
      isReplay = false;
      isLoading = false;
    }

    void startGame() {
      isStart = true;
      isLoading= true;

      notifyListeners();
    }

    void stopGame() {
      isStart = false;

      notifyListeners();
    }

    void quitGame() {
      isQuit = true;

      notifyListeners();
    }

    void replayGame() {
      isReplay = true;
      isLoading = true;

      notifyListeners();
    }

    void startLoading() {
      isLoading = true;

      notifyListeners();
    }

    void stopLoading() {
      isLoading = false;
      isReplay = false;
      isStart = false;
      isQuit = false;

      notifyListeners();
    }
}