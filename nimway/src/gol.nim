import random
import godot
import godotapi/[node_2d, position_2d, timer, packed_scene, control, scene_tree, resource_loader, button]
import cell

gdobj GoL of Node2D:
  #game board settings
  var width* = 10
  var height* = 10
  var grid: seq[Cell] = newSeq[Cell](self.width * self.height)
  var cellSize* = 32
  var spawnRate* = 50
  var spacer = 5

  var startPosition: Position2D
  var stepTimer: Timer
  var resetButton: Button

  var pk_cell = load("res://scenes/Cell.tscn") as PackedScene

  proc initGrid*() =
    for y in 0..<self.height:
      for x in 0..<self.width:
        var newCell = self.pk_cell.instance() as Cell
        newCell.initTile(x, y)
        newCell.rectPosition = vec2(self.startPosition.position.x + float(x * (self.cellSize+self.spacer)), self.startPosition.position.y + float(y*(self.cellSize+self.spacer)))
        self.getTree().root.getNode("GameOfLife").addChild(newCell)
        self.grid[y * self.width + x] = newCell

  proc randomizeGrid*() =
    for y in 0..<self.height:
      for x in 0..<self.width:
        let cell = self.grid[y * self.width + x]
        if rand(100) <= self.spawnRate:
          cell.setKind(CellKind.Living)
        else:
          cell.setKind(CellKind.Dead)

  #helper function to get neighbors status
  proc getLivingNeighbors*(cell: Cell): int =
    for i in -1..1:
      for j in -1..1:
        if i == 0 and j == 0:
          continue

        let x = cell.x + i
        let y = cell.y + j
        if x >= 0 and x < self.width and y >= 0 and y < self.height:
          if self.grid[y * self.width + x].getKind == CellKind.Living:
            result += 1

  #main moving cog of the game, iterate over the board and apply conway's rules
  proc step*() =
    var kinds = newSeq[CellKind](0)
    for y in 0..<self.height:
      for x in 0..<self.width:
        let cell = self.grid[y * self.width + x]
        let livingNeighbors = self.getLivingNeighbors(cell)

        #living
        if cell.getKind() == CellKind.Living:
          if livingNeighbors < 2 or livingNeighbors > 3:
            kinds.add(CellKind.Dead)
          else:
            kinds.add(CellKind.Living)
        #dead
        elif livingNeighbors == 3:
            kinds.add(CellKind.Living)
        else:
            kinds.add(CellKind.Dead)

    #set the kinds
    for y in 0..<self.height:
      for x in 0..<self.width:
        let idx = y * self.width + x
        self.grid[idx].setKind(kinds[idx])


  proc onStepTimerTimeout*() {.gdExport.} =
    self.step()

  proc onResetButtonPressed*() {.gdExport.} =
    self.randomizeGrid()

  method ready*() =
    randomize()
    self.startPosition = self.getNode("StartPosition").as(Position2D)
    self.stepTimer = self.getNode("StepTimer").as(Timer)
    self.resetButton = self.getNode("ResetButton").as(Button)
    discard self.resetButton.connect("pressed", self, "on_reset_button_pressed", newArray())
    discard self.stepTimer.connect("timeout", self, "on_step_timer_timeout", newArray())
    self.initGrid()
    self.randomizeGrid()


