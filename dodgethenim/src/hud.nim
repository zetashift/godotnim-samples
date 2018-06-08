import godot, canvas_layer, timer, label, asyncdispatch

gdobj Hud of CanvasLayer:
  var messageTimer: Timer
  var messageLabel: Label
  var startButton: Button
  var scoreLabel: Label


  proc init() =
    addUserSignal("start_game")

  proc showMessage*(text: string) =
    messageTimer = getNode("MessageTimer").as(Timer)
    messageLabel = getNode("MessageLabel").as(Label)
    messageLabel.text = text
    messageLabel.show()
    messageTimer.start()

  proc showGameOver*() =
    showMessage("Game Over")
    startButton = getNode("StartButton").as(Button)
    messageTimer = getNode("MessageTimer").as(Timer)
    messageLabel = getNode("MessageLabel").as(Label)
    discard sleepAsync(messageTimer.waitTime.int * 1000)
    messageLabel.text = "Game Over!"
    messageLabel.show()
    startButton.show()

  proc updateScore*(score: int) =
    scoreLabel = getNode("ScoreLabel").as(Label)
    scoreLabel.text = $score

  proc onStartButtonPressed*() {.gdExport.} =
    startButton = getNode("StartButton").as(Button)
    startButton.hide()
    emitSignal("start_game")

  proc onMessageTimerTimeout*() {.gdExport.} =
    messageLabel = getNode("MessageLabel").as(Label)
    messageLabel.hide()

  method ready*() =
    messageTimer = getNode("MessageTimer").as(Timer)
    startButton = getNode("StartButton").as(Button)
    discard messageTimer.connect("timeout", self, "on_message_timer_timeout", newArray())
    discard startButton.connect("pressed", self, "on_start_button_pressed", newArray())

