import godot
import godotapi/[canvas_layer, timer, label]
import asyncdispatch

gdobj Hud of CanvasLayer:
  var messageTimer: Timer
  var messageLabel: Label
  var startButton: Button
  var scoreLabel: Label

  proc init() =
    self.addUserSignal("start_game")

  proc showMessage*(text: string) =
    self.messageLabel.text = text
    self.messageLabel.show()
    self.messageTimer.start()

  proc showGameOver*() =
    self.showMessage("Game Over")
    discard sleepAsync(self.messageTimer.waitTime.int * 1000)
    self.messageLabel.text = "Game Over!"
    self.messageLabel.show()
    self.startButton.show()

  proc updateScore*(score: int) =
    self.scoreLabel.text = $score

  proc onStartButtonPressed*() {.gdExport.} =
    self.startButton.hide()
    self.emitSignal("start_game")

  proc onMessageTimerTimeout*() {.gdExport.} =
    self.messageLabel.hide()

  method ready*() =
    self.messageTimer = self.getNode("MessageTimer").as(Timer)
    self.messageLabel = self.getNode("MessageLabel").as(Label)
    self.startButton = self.getNode("StartButton").as(Button)
    self.scoreLabel = self.getNode("ScoreLabel").as(Label)
    discard self.messageTimer.connect("timeout", self, "on_message_timer_timeout", newArray())
    discard self.startButton.connect("pressed", self, "on_start_button_pressed", newArray())

