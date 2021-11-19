import godot
import godotapi / [engine, polygon_2d, node_2d, input, control, canvas_item, scene_tree]

gdobj test_poly of Node2d:

  proc start*(pos: Vector2) = discard

  method ready*() = print("present")
    #discard

  #tank movement
  method process*(delta: float64) =
    #global movement commented out
    #if isActionPressed("ui_right"): self.editSetPosition(vec2(self.editGetPosition.x + 1.0'f32, self.editGetPosition.y + 0.0'f32))
    if isActionPressed("ui_up"): self.moveLocalY(-1.0)
    elif isActionPressed("ui_up"): self.moveLocalY(+1.0)
    if isActionPressed("ui_right"): self.editSetRotation(self.editGetRotation + 0.01'f64)
    elif isActionPressed("ui_left"): self.editSetRotation(self.editGetRotation - 0.01'f64)
