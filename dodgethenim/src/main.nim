import godot, packed_scene, random, area_2d, timer, player, path_follow_2d,
       random, rigid_body_2d, mob, math, hud, resource_loader

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
    mobTimer = getNode("MobTimer").as(Timer)
    scoreTimer = getNode("ScoreTimer").as(Timer)
    mobTimer.start()
    scoreTimer.start()

  proc onScoreTimerTimeout*() {.gdExport.} =
    var hud = getNode("Hud").as(Hud)
    hud = getNode("Hud").as(Hud)
    score += 1
    hud.updateScore(score)

  proc onMobTimerTimeout*() {.gdExport.} =
    #choose a random location on path2d
    mobSpawnLocation = getNode("MobPath/MobSpawnLocation").as(PathFollow2D)
    mobSpawnLocation.offset = rand(high(int32)).float64 #ugly ass hack

    var direction = mobSpawnLocation.rotation + PI/2
    direction += rand(PI/2)

    #add the mob instance to our scene
    var mobInstance = mob.instance().as(RigidBody2D)
    mobInstance.position = mobSpawnLocation.position
    mobInstance.rotation = direction
    mobInstance.linearVelocity = vec2(rand(150.float..250.float), 0).rotated(direction)
    addChild(mobInstance)

  proc gameOver*() {.gdExport.} =
    hud = getNode("Hud").as(Hud)
    mobTimer = getNode("MobTimer").as(Timer)
    scoreTimer = getNode("ScoreTimer").as(Timer)

    scoreTimer.stop()
    mobTimer.stop()
    hud.showGameOver()

  proc newGame*() {.gdExport.}   =
    var hud = getNode("Hud").as(Hud)
    score = 0
    player = getNode("Player").as(Player)
    hud = getNode("Hud").as(Hud)
    startTimer = getNode("StartTimer").as(Timer)
    startPosition = getNode("StartPosition").as(Position2D)
    hud.updateScore(score)
    hud.showMessage("Get Ready!")
    player.start(startPosition.position)
    startTimer.start()

  method ready*() =
    randomize()
    player = getNode("Player").as(Player)
    startTimer = getNode("StartTimer").as(Timer)
    scoreTimer = getNode("ScoreTimer").as(Timer)
    mobTimer = getNode("MobTimer").as(Timer)

    discard player.connect("hit", self, "game_over", newArray())
    discard startTimer.connect("timeout", self, "on_start_timer_timeout", newArray())
    discard scoreTimer.connect("timeout", self, "on_score_timer_timeout", newArray())
    discard mobTimer.connect("timeout", self, "on_mob_timer_timeout", newArray())
    var hud = getNode("Hud").as(Hud)
    discard hud.connect("start_game", self, "new_game", newArray())