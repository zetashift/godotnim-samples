import random
import godot
import godotapi/[rigid_body_2d, animated_sprite, visibility_notifier_2d]

gdobj Mob of RigidBody2d:
  var minSpeed* {.gdExport.} = 150
  var maxSpeed* {.gdExport.} = 250
  var mobKinds: seq[string] = @["walk", "fly", "swim"]
  var animatedSprite: AnimatedSprite
  var visibility: VisibilityNotifier2D

  proc onVisibilityScreenExited*() {.gdExport.} =
    self.queueFree()

  method ready*() =
    self.visibility = self.getNode("Visibility").as(VisibilityNotifier2D)
    self.animatedSprite = self.getNode("AnimatedSprite").as(AnimatedSprite)
    self.animatedSprite.animation = sample(self.mobKinds)
    discard self.visibility.connect("screen_exited", self, "on_visibility_screen_exited", newArray())

