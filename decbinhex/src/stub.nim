when not defined(release):
  import segfaults # converts segfaults into NilAccessError
{.push warnings: off.}
import test_poly
import main
