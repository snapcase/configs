--
-- xmonad.hs
--
-- Thu 24 Mar 2011
--
-- Modified ManageHook and added vim folds
--

-- Imports {{{

import XMonad
import IO
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Scratchpad
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Spacing
import XMonad.Layout.Named
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace	(onWorkspace)
import XMonad.Layout.OneBig

import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Util.Themes
import XMonad.Actions.GridSelect

import qualified XMonad.StackSet as W
import Data.List

-- }}}

-- Main {{{

main = do
	d <- spawnPipe myStatusBar
	spawn myTopBar
	xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig 
		{ workspaces = myWorkspaces
		, terminal = myTerminal
		, modMask = mod4Mask
		, borderWidth = 1
		, normalBorderColor = "#161616"
		, focusedBorderColor = "#7992B3"
		, logHook = myLogHook d
		, manageHook = myManageHook
		, layoutHook = myLayoutHook
		, startupHook = setWMName "LG3D"
		} `additionalKeysP` myKeys

-- }}}

-- Options {{{

--myWorkspaces	= ["main", "www", "voip", "misc", "irc"] ++ map show [6..9]
myWorkspaces =  [ "^i(/home/snapcase/.icons/xbm8x8/terminal.xbm) term"  
                , "^i(/home/snapcase/.icons/xbm8x8/fox.xbm) www"        
                , "voip"                                                
                , "misc"                                                
                , "irc" ]                                               
                ++ map show [6..9]                                      
myTerminal      = "urxvtc"

-- }}}

-- Layouts {{{
myLayoutHook = avoidStruts $ smartBorders
                           $ onWorkspace (myWorkspaces !! 1) (Full ||| myTabbed)  -- www
			   $ onWorkspace (myWorkspaces !! 2) imLayout             -- voip
                           $ onWorkspace (myWorkspaces !! 4) oneBigLayout         -- irc
			   $ standardLayouts
  where
	standardLayouts = named "Tall" tiled 
			||| named "Mirror Tall" (Mirror tiled) 
			||| Full 
                    	||| myTabbed
                    	||| oneBigLayout 

        myTabbed        = tabbed shrinkText (theme smallClean)

	imLayout	= named "IM" . reflectHoriz $
			  withIM (1/7) (And (ClassName "Skype")  (And (Role "") (Not (Title "Options")))) standardLayouts

  	oneBigLayout 	= named "OneBig" ( spacing 5 $ Mirror $ OneBig (2/3) (2/3) )

	tiled	  	= spacing 5 (Tall nmaster delta ratio)
	nmaster		= 1
	delta		= 3/100
	ratio		= 1/2

-- }}}

-- LogHook {{{

myLogHook h = do
		--fadeInactiveLogHook fadeAmount
		dynamicLogWithPP $ defaultPP
                        {-
			{ ppCurrent         = dzenColor "#89B6E2" "" . pad
			, ppHidden          = dzenColor "#909090" ""  . noScratchPad
			, ppLayout          = wrap "^fg(#909090)|^fg(#89B6E2)" "^fg(#909090)|^fg()" . pad
			, ppUrgent	    = dzenColor "#F57900" "" . pad
			, ppTitle           = dzenColor "#89B6E2" "" . shorten 40 
			, ppWsSep           = " "
			, ppSep             = " "
			, ppOutput          = hPutStrLn h
			} 
			  where
			    noScratchPad ws = if ws == "NSP" then "" else pad ws
                        -}
                        { ppOutput          = hPutStrLn h
                        , ppSep             = " "
                        , ppWsSep           = " "
                        , ppCurrent         = wrap "^fg(#ffffff)^bg(#60a0c0) " " ^fg()^bg()"
                        , ppUrgent          = wrap "^fg(#ffffff)^bg(#aff73e)" "^fg()^bg()"
                        , ppVisible         = wrap "^fg(#b8bcb8)^bg(#484848)" "^fg()^bg()"
                        --, ppHidden          = wrap "^fg(#b8bcb8)^bg(#484848)" "^fg()^bg()" . noScratchPad
                        , ppHidden          = dzenColor "#909090" ""  . noScratchPad
                        --, ppHiddenNoWindows = wrap "^fg(#484848)^bg(#000000)" "^fg()^bg()" . noScratchPad
                        --, ppTitle           = wrap "^fg(#9d9d9d)^bg(#000000)" "^fg()^bg()" . wrap "" " ^fg(#a488d9)>^fg(#60a0c0)>^fg(#444444)>"
                        , ppTitle           = wrap "^fg(#9d9d9d)" "^fg()^bg()" . wrap "" "^fg(#a488d9)>^fg(#60a0c0)>^fg(#444444)>" . shorten 40
                        , ppLayout          = wrap "^fg(#909090)|^fg(#89B6E2)" "^fg(#909090)|^fg()" . pad
                        }                        
                          where
			    noScratchPad ws = if ws == "NSP" then "" else pad ws

-- }}}

-- StatusBars {{{

myStatusBar = "dzen2 -ta l -fn -*-terminus-*-*-*-*-12-*-*-*-*-*-*-* -x 0 -y 1034 -h 16 -ta l -fg '#888888' -bg '#181818' -e 'onstart=lower'"
myTopBar  = "conky -c ~/.conky/dzen_conkyrc | dzen2 -p -ta r -fn -*-terminus-*-*-*-*-12-*-*-*-*-*-*-* -x 0 -y 0 -h 17 -w 1680 -fg '#89B6E2' -bg '#181818'"

-- }}}

-- ManageHook {{{

myManageHook = (composeAll . concat $
	[ [className =? c                                   --> doCenterFloat                 | c	  <- myFloats   ]
	, [className =? c                                   --> doShift "voip"                | c	  <- myIMs      ]
	, [className =? c                                   --> doShift (myWorkspaces !! 1)   | c	  <- myBrowsers ]
	, [resource  =? rs                                  --> doFloat		              | rs	  <- myRFloats  ]
        , [className =? "Skype"     <&&> role =?  "Chats"   --> doCenterFloat]
        , [isFullscreen                                     --> doFullFloat]
	]) <+> manageScratchPad <+> manageDocks
  where
    role        = stringProperty "WM_WINDOW_ROLE"

    myFloats	= ["MPlayer", "feh", "Xmessage", "Qiv", "Wine", "Mumble", "Uim-pref-gtk"]
    myRFloats   = ["Browser"]
    myBrowsers	= ["Firefox", "Uzbl-core"]
    myIMs       = ["Skype"]


    manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
      where
        h = 0.1     -- terminal height, 10%
        w = 1       -- terminal width, 100%
        t = 1 - h   -- distance from top edge, 90%
        l = 1 - w   -- distance from left edge, 0%

-- }}}

-- Keys {{{

myKeys =
	[ ("M-<Backspace>"	, focusUrgent		        )  
	, ("M-s"	        , scratchPad		        )
	, ("M-q"	        , spawn myRestart	        )
        , ("M-p"                , shellPrompt defaultXPConfig   )
        , ("M-g"                , goToSelected defaultGSConfig  )
        , ("M-C-l"              , spawn xlock                   )
	]
  where
	  scratchPad = scratchpadSpawnActionTerminal myTerminal
	  myRestart = "for pid in `pgrep dzen2`; do kill -9 $pid; done && xmonad --recompile && xmonad --restart"
          xlock = "xlock -mode blank -geometry 1x1 -font -*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"

-- }}}

-- vim:foldmethod=marker foldmarker={{{,}}}
