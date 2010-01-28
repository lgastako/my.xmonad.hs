import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W

import System.IO

myManageHook = composeAll . concat $
    [ [ className =? "Firefox-bin" --> doShift "web"  ]
    ]


myWorkspaces = [ "codeterms", "emacs", "firefox", "chrome", "xterms" ] ++ map show [6..7] ++ [ "notes", "chat" ]

main = do
    conf <- dzen defaultConfig
    xmonad $ conf
        { workspaces = myWorkspaces,
          manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig,
          layoutHook = avoidStruts $ smartBorders  $  layoutHook defaultConfig,
          borderWidth = 2,
          startupHook = setWMName "LG3D",
          terminal = "urxvt -rv -tr -sh 35 -sl 9999",
          logHook = dynamicLogWithPP $ dzenPP
        } `additionalKeys` myKeys

myKeys =
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock"),
      ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s"),
      ((0, xK_Print), spawn "scrot")
    ]
    ++
    [((m .|. mod4Mask, k), windows $ f i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
