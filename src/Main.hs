module Main where

import Data.Text (Text, unpack, splitOn)
import Graphics.UI.Gtk
    ( set,
      containerAdd,
      onDestroy,
      widgetShowAll,
      buttonNewWithLabel,
      onClicked,
      entryGetText,
      entryNew,
      entryText,
      initGUI,
      mainGUI,
      mainQuit,
      vBoxNew,
      windowDefaultHeight,
      windowDefaultWidth,
      windowNew,
      windowTitle,
      AttrOp((:=)) )
import Relude.Unsafe ( read )


main :: IO ()
main = do
  _ <- initGUI
  window <- windowNew

  -- Set window default properties
  set
    window
    [ windowTitle := ("HexGrid Map Creator" :: String)
    , windowDefaultWidth := 300
    , windowDefaultHeight := 200
    ]

  -- Create and set up the Entry widget for input
  input <- entryNew
  set input [entryText := ("Enter dimensions (e.g., 10x10)" :: String)]

  -- Create a button to handle the input
  button <- buttonNewWithLabel ("Create HexGrid" :: String)
  _ <- onClicked button $ do
    dimensions <- entryGetText input
    let (width, height) = parseDimensions dimensions
    -- Create new window with hex grid
    _ <- createHexGridWindow width height
    pass

  -- Box to hold the input and button
  box <- vBoxNew False 0
  containerAdd box input
  containerAdd box button
  containerAdd window box

  -- Show the window
  widgetShowAll window

  _ <- onDestroy window mainQuit
  mainGUI

createHexGridWindow :: Int -> Int -> IO ()
createHexGridWindow width height = do
  window <- windowNew

  -- Set window default properties
  set
    window
    [ windowTitle := ("HexGrid Map" :: String)
    , windowDefaultWidth := 500
    , windowDefaultHeight := 500
    ]

  -- Here, you would create and add the hex grid to the window
  -- using the dimensions provided by the user

  -- Show the window
  widgetShowAll window
  pass

parseDimensions :: Text -> (Int, Int)
parseDimensions dims =
  let dimList = splitOn "x" dims
      readList = map (read . unpack) dimList
   in case readList of
        [width, height] -> (width, height)
        _ -> error "Invalid input format, expected 'widthxheight'"
