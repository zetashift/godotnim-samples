import godot, strutils
import godotapi / [gd_os, node_2d, engine, input, control, scene_tree, line_edit, base_button, label]
import convert

let
 hex_letters:set[char] = HexDigits - Digits
 nonhex_chars:set[char] = AllChars - HexDigits
 nonbinary_numbers:set[char] = Digits - {'0', '1'}

gdobj main of Control:

 method ready*() =
  gd_os.set_min_window_size(vec2(325, 200))
  gd_os.set_max_window_size(vec2(960, 240))
  print "ready"

 proc disable_all_buttons(message:string) =
  self.getNode("grid/decimal_button").BaseButton.disabled = true
  self.getNode("grid/binary_button").BaseButton.disabled = true
  self.getNode("grid/hex_button").BaseButton.disabled = true
  self.getNode("grid/a/outlabel").Label.text = message

# gdExport pragma seems needed for signals to function properly
 proc on_inbox_text_changed(intext:string) {.gdExport.} =
  #print intext.len
  if nonhex_chars in intext or intext.len == 0:
   #Important! any proc called that also needs to deal with nodes will error if not called with self
   #(or self as a parameter, but that looks odd since it's not+cannot be defined as an argument)
   self.disable_all_buttons("Waiting for valid input.")
   return
  if intext.len > 63:
   self.disable_all_buttons("Input too large, causes overflow!")
   return
  self.getNode("grid/a/outlabel").Label.text = "Waiting for button choice."
  self.getNode("grid/hex_button").BaseButton.disabled = false
  if intext.len > 15:
   self.getNode("grid/hex_button").BaseButton.disabled = true
   if hex_letters in intext:
    self.getNode("grid/decimal_button").BaseButton.disabled = true
    self.getNode("grid/binary_button").BaseButton.disabled = true
    self.getNode("grid/a/outlabel").Label.text = "Input hexadecimal too large, causes overflow!"
    return
  if hex_letters in intext:
   self.getNode("grid/decimal_button").BaseButton.disabled = true
   self.getNode("grid/binary_button").BaseButton.disabled = true
   self.getNode("grid/a/outlabel").Label.text = ("Live hexadecimal conversion is:\n" & $intext.parseHexInt & " in decimal")
   return
  if intext.len < 20 and parseInt(intext) == 0:
   self.disable_all_buttons("Waiting for valid input.")
   return
  if nonbinary_numbers in intext:
   self.getNode("grid/binary_button").BaseButton.disabled = true
   self.getNode("grid/decimal_button").BaseButton.disabled = false
  else:
   self.getNode("grid/binary_button").BaseButton.disabled = false
   self.getNode("grid/decimal_button").BaseButton.disabled = false
   if (self.getNode("grid/binary_check").BaseButton).is_pressed:
    if intext.len < 20: self.getNode("grid/a/outlabel").Label.text = ("Live binary conversion is:\n" & $intext.parseBinInt & " in decimal")
    else: self.getNode("grid/a/outlabel").Label.text = ("Input decimal too large to parse for live convert, please use button")

 proc submit_decimal() {.gdExport.} =
  #called proc is imported from convert.nim
  self.getNode("grid/a/outlabel").Label.text = convert_from_decimal(self.getNode("grid/inbox").LineEdit.text)

 proc submit_binary() {.gdExport.} =
  self.getNode("grid/a/outlabel").Label.text = convert_from_binary(self.getNode("grid/inbox").LineEdit.text)

 proc submit_hex() {.gdExport.} =
  self.getNode("grid/a/outlabel").Label.text = convert_from_hexadecimal(self.getNode("grid/inbox").LineEdit.text)
  #self.getNode("grid/inbox").queue_free()

 method process*(delta: float64) = discard
