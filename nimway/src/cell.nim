import godot
import animation_player, control

type
  CellKind* {.pure.} = enum
    Living
    Dead

gdobj Cell of Control:
  var kind: CellKind
  var x*, y*: int
  var anim: AnimationPlayer

  method ready*() =
    anim = getNode("AnimationPlayer").as(AnimationPlayer)

  proc initTile*(x,y: int) =
    self.x = x
    self.y = y

  proc setKind*(kind: CellKind) =
    self.kind = kind
    case kind:
    of CellKind.Living:
      anim.play("Living")
    of CellKind.Dead:
      anim.play("Dead")

  proc getKind*(): CellKind =
    kind

