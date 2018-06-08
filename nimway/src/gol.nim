import godot, node_2d, position_2d, timer,
       packed_scene, cell, control, scene_tree, resource_loader, random,
       button

gdobj GoL of Node2D:
  #game board settings
  var width* = 10
  var height* = 10
  var grid: seq[Cell] = newSeq[Cell](width * height)
  var cellSize* = 32
  var spawnRate* = 50
  var spacer = 5

  var startPosition: Position2D
  var stepTimer: Timer
  var resetButton: Button

  var cell = load("res://scenes/cell.tscn") as PackedScene

  proc initGrid*() =
    for y in 0..<height:
      for x in 0..<width:
        var newCell = cell.instance() as Cell
        newCell.initTile(x, y)
        newCell.rectPosition = vec2(startPosition.position.x + float(x * (cellSize+spacer)), startPosition.position.y + float(y*(cellSize+spacer)))
        getTree().root.getNode("GameOfLife").addChild(newCell)
        grid[y * width + x] = newCell

  proc randomizeGrid*() =
    for y in 0..<height:
      for x in 0..<width:
        var cell = grid[y * width + x]
        if rand(100) <= spawnRate:
          cell.setKind(CellKind.Living)
        else:
          cell.setKind(CellKind.Dead)

  #helper function to get neighbors status
  proc getLivingNeighbors*(cell: Cell): int =
    var livingNeighbors = 0
    for i in -1..<2:
      for j in -1..<2:
        var x = cell.x + i
        var y = cell.y + j
        if i == 0 and j == 0:
          discard
        elif x >= 0 and x <= width-1 and y >= 0 and y <= height-1:
          if grid[y * width + x].getKind == CellKind.Living:
            livingNeighbors += 1
    result = livingNeighbors


  #main moving cog of the game, iterate over the board and apply conway's rules
  proc step*() =
    var kinds = newSeq[CellKind](0)
    for y in 0..<height:
      for x in 0..<width:
        var cell = grid[y * width + x]
        var livingNeighbors = getLivingNeighbors(cell)
        #living
        if cell.getKind() == CellKind.Living:
          if livingNeighbors < 2 or livingNeighbors > 3:
            kinds.add(CellKind.Living)
          elif livingNeighbors == 2 or livingNeighbors == 3:
            kinds.add(CellKind.Dead)
        #dead
        elif livingNeighbors == 3:
            kinds.add(CellKind.Living)
        else:
            kinds.add(CellKind.Dead)

    #set the kinds
    var index = 0
    for y in 0..<height:
      for x in 0..<width:
        grid[y * width + x].setKind(kinds[index])
        index += 1

  proc onStepTimerTimeout*() {.gdExport.} =
    step()

  proc onResetButtonPressed*() {.gdExport.} =
    randomizeGrid()

  method ready*() =
    randomize()
    startPosition = getNode("StartPosition").as(Position2D)
    stepTimer = getNode("StepTimer").as(Timer)
    resetButton = getNode("ResetButton").as(Button)
    discard resetButton.connect("pressed", self, "on_reset_button_pressed", newArray())
    discard stepTimer.connect("timeout", self, "on_step_timer_timeout", newArray())
    initGrid()
    randomizeGrid()


