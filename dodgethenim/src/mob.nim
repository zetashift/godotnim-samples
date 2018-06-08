import godot, rigid_body_2d, animated_sprite, random,
       visibility_notifier_2d

gdobj Mob of RigidBody2d:
  var minSpeed* {.gdExport.} = 150
  var maxSpeed* {.gdExport.} = 250
  var mobKinds: seq[string] = @["walk", "fly", "swim"]
  var animatedSprite: AnimatedSprite
  var visibility: VisibilityNotifier2D

  proc onVisibilityScreenExited*() {.gdExport.} =
    queueFree()

  method ready*() =
    visibility = getNode("Visibility").as(VisibilityNotifier2D)
    animatedSprite = getNode("AnimatedSprite").as(AnimatedSprite)
    animatedSprite.animation = mobKinds.rand()
    discard visibility.connect("screen_exited", self, "on_visibility_screen_exited", newArray())

