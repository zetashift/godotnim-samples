import random, math
import godot
import godotapi/[packed_scene, area_2d, timer, path_follow_2d, rigid_body_2d, resource_loader]
import player, mob, hud

gdobj Main of Node:
  var score: int
  var mob* {.gdExport.}: PackedScene
  var player: Player
  var mobTimer: Timer
  var scoreTimer: Timer
  var startTimer: Timer
  var startPosition: Position2D
  var mobSpawnLocation: PathFollow2D
  var hud: Hud

  proc onStartTimerTimeout*() {.gdExport.} =
    self.mobTimer.start()
    self.scoreTimer.start()

  proc onScoreTimerTimeout*() {.gdExport.} =
    self.score += 1
    self.hud.updateScore(self.score)

  proc onMobTimerTimeout*() {.gdExport.} =
    #choose a random location on path2d
    self.mobSpawnLocation.offset = rand(high(int32)).float64 #ugly ass hack

    var direction = self.mobSpawnLocation.rotation + PI/2
    direction += rand(PI/2)

    #add the mob instance to our scene
    var mobInstance = self.mob.instance().as(RigidBody2D)
    mobInstance.position = self.mobSpawnLocation.position
    mobInstance.rotation = direction
    mobInstance.linearVelocity = vec2(rand(150.float..250.float), 0).rotated(direction)
    self.addChild(mobInstance)

  proc gameOver*() {.gdExport.} =
    self.scoreTimer.stop()
    self.mobTimer.stop()
    self.hud.showGameOver()

  proc newGame*() {.gdExport.}   =
    self.score = 0
    self.hud.updateScore(self.score)
    self.hud.showMessage("Get Ready!")
    self.player.start(self.startPosition.position)
    self.startTimer.start()

  method ready*() =
    randomize()
    self.player = self.getNode("Player").as(Player)
    self.startTimer = self.getNode("StartTimer").as(Timer)
    self.scoreTimer = self.getNode("ScoreTimer").as(Timer)
    self.mobTimer = self.getNode("MobTimer").as(Timer)
    self.startPosition = self.getNode("StartPosition").as(Position2D)
    self.mobSpawnLocation = self.getNode("MobPath/MobSpawnLocation").as(PathFollow2D)
    self.hud = self.getNode("Hud").as(Hud)

    discard self.player.connect("hit", self, "game_over", newArray())
    discard self.startTimer.connect("timeout", self, "on_start_timer_timeout", newArray())
    discard self.scoreTimer.connect("timeout", self, "on_score_timer_timeout", newArray())
    discard self.mobTimer.connect("timeout", self, "on_mob_timer_timeout", newArray())
    discard self.hud.connect("start_game", self, "new_game", newArray())