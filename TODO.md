
- Let user pick RGB colors

- Extra drawing primitives:
  - circles

- HTML output mode?

- Better encapsulation of layers and their metadata within app state

-----------------------------------------------------------------
Dealing with the larger color space:

- UI shows "favorite" colors, list can be grown by the user
- Favorites get stored in the file along with canvas data, reloaded on
  startup
- Need UI for picking from 256 color spectrum to choose favorites to add
  to palette selector
- Attributes still get encoded directly in the output data and canvas
- Eye dropper then just has to find out whether the color is in the
  favorites list, and if not, add it.
- Need to have two palettes: Fg and Bg, rather than the same palette
  that gets used for both. The latter is a good startup default, but
  ultimately the palettes need to be able to vary independently.
- The palette needs to become part of the canvas data structure so it
  can be de/serialized with the canvas data
