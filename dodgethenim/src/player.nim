import godot
import godotapi/[node_2d, area_2d, control, canvas_item, input, animated_sprite,
       scene_tree, collision_shape_2d, rigid_body_2d]

gdobj Player of Area2D:
  var speed* {.gdExport.} = 400
  var screenSize: Vector2
  var collisionShape2D: CollisionShape2D
  var animatedSprite: AnimatedSprite
  var body: RigidBody2D

  method init*() =
    self.addUserSignal("hit")

  proc onPlayerBodyEntered*(body: Object) {.gdExport.} =
    self.hide()
    self.emitSignal("hit")
    self.collisionShape2D.disabled = true

  proc start*(pos: Vector2) =
    self.position = pos
    self.show()
    self.collisionShape2D.disabled = false

  method ready*() =
    self.screenSize = self.getViewPortRect().size
    self.collisionShape2D = self.getNode("CollisionShape2D").as(CollisionShape2D)
    self.animatedSprite = self.getNode("AnimatedSprite").as(AnimatedSprite)
    discard self.connect("body_entered", self, "on_player_body_entered", newArray())
    self.hide()

  method process*(delta: float64) =
    var velocity = vec2()
    #handle movement
    if isActionPressed("ui_right"): velocity.x += 1
    if isActionPressed("ui_left"):  velocity.x -= 1
    if isActionPressed("ui_down"):  velocity.y += 1
    if isActionPressed("ui_up"):    velocity.y -= 1

    #check if the player is moving so we can start/stop the animation
    if velocity.length() > 0:
      velocity = velocity.normalized() * self.speed.float64
      self.animatedSprite.play()
    else:
      self.animatedSprite.stop()
    #prevent player from leaving screen using clamp()
    self.position = (self.position + velocity * delta)
    self.position = vec2(clamp(self.position.x, 0, self.screenSize.x),
                         clamp(self.position.y, 0, self.screenSize.y))
    #handle left and down animation by flipping the sprite
    if velocity.x != 0:
      self.animatedSprite.animation = "right"
      self.animatedSprite.flipH = velocity.x < 0
      self.animatedSprite.flipV = false
    elif velocity.y != 0:
      self.animatedSprite.animation = "up"
      self.animatedSprite.flipV = velocity.y > 0


