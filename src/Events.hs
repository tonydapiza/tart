module Events
  ( handleEvent
  )
where

import Brick
import Lens.Micro.Platform
import qualified Graphics.Vty as V

import Types
import Events.Main
import Events.CharacterSelect
import Events.PaletteEntrySelect
import Events.ToolSelect
import Util

handleEvent :: AppState -> BrickEvent Name e -> EventM Name (Next AppState)
handleEvent s (VtyEvent (V.EvResize _ _)) = do
    s' <- updateExtents s
    continue =<< resizeCanvas s'
handleEvent s e = do
    s' <- updateExtents s

    let next = case e of
          MouseDown n _ _ _ ->
              if s'^.dragging == Nothing
              then Just (e, s' & dragging .~ Just n)
              else if Just n == s'^.dragging
                   then Just (e, s')
                   else Nothing
          MouseUp _ _ _ ->
              Just (e, s' & dragging .~ Nothing)
          _ ->
              Just (e, s')

    case next of
        Nothing -> continue s'
        Just (ev, st) ->
            case st^.mode of
                Main                 -> handleMainEvent st ev
                FgPaletteEntrySelect -> handlePaletteEntrySelectEvent st ev
                BgPaletteEntrySelect -> handlePaletteEntrySelectEvent st ev
                ToolSelect           -> handleToolSelectEvent st ev
                CharacterSelect      -> handleCharacterSelectEvent st ev

updateExtents :: AppState -> EventM Name AppState
updateExtents s = do
    fgExtent <- lookupExtent FgSelector
    bgExtent <- lookupExtent BgSelector
    tsExtent <- lookupExtent ToolSelector

    return $ s & fgPaletteSelectorExtent .~ fgExtent
               & bgPaletteSelectorExtent .~ bgExtent
               & toolSelectorExtent      .~ tsExtent
