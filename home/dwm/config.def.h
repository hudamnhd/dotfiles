/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
/* appearance */
static const unsigned int borderpx       = 1;        /* border pixel of windows */
static const unsigned int snap           = 32;       /* snap pixel */
static const unsigned int gappih    = 20;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 30;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray             = 1;        /* 0 means no systray */
static const int showbar                 = 1;        /* 0 means no bar */
static const int topbar                  = 1;        /* 0 means bottom bar */
static const char *fonts[]               = { "IosevkaTree Nerd Font:style=SemiBold:pixelsize=15:antialias=true:autohint=true" };
static const char dmenufont[]            = "IosevkaTree Nerd Font:style=SemiBold:pixelsize=15:antialias=true:autohint=true";
static const char col_gray1[]            = "#222222";
static const char col_gray2[]            = "#444444";
static const char col_gray3[]            = "#bbbbbb";
static const char col_gray4[]            = "#eeeeee";
static const char col_cyan[]             = "#005577";
static const char *colors[][3]           = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_gray4  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4",};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	// { "Firefox",  NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
};


/* layout(s) */
static const float mfact        = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEYA Mod1Mask
#define MODKEYB Mod2Mask
#define MODKEY Mod4Mask	
      #define TAGKEYS(KEY,TAG) \
      	{ MODKEY,                   KEY,      view,           {.ui = 1 << TAG} }, \
     	{ MODKEYB,           		KEY,      toggleview,     {.ui = 1 << TAG} }, \
     	{ MODKEYA,             		KEY,      tag,            {.ui = 1 << TAG} }, \
      	{ MODKEYB|ControlMask, 		KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/bash", "-c", cmd, NULL } }


/* commands */
static char dmenumon[2]             = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]       = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]        = { "alacritty", NULL };
static const char *clipmenu[]       = { "clipmenu", NULL };
static const char *rofi[]           = { "/home/hudamnhd/.local/bin/rofi-custom", NULL };
static const char *tabbed[]         = { "tabbed", "alacritty", "--embed", NULL };
static const char *volumedown[]     = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-10%", NULL };
static const char *volumeup[]       = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+10%", NULL };
static const char *mute[]           = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };
static const char *rofipower[]      = { "rofi", "-show", "p", "-modi", "p:~/.local/bin/rofi-power-menu", "-me-select-entry", "", "-me-accept-entry", "MousePrimary",  NULL };
static const char *nakedquit[]      = { "nakedquit",  NULL };
static const char *popmenu[]        = { "popmenu", "0",  NULL };
static const char *combinemenu[]    = { "combinemenu",  NULL };
static const char *mocp[]           = {"/home/hudamnhd/.local/bin/mocp.sh", NULL};
static const char *screenshot[]     = {"/home/hudamnhd/.local/bin/screenshot", NULL};
static const char *screenshotfull[] = {"/home/hudamnhd/.local/bin/screenshot-full", NULL};
static const char *screenrecord[]   = {"/home/hudamnhd/.local/bin/screenrecord", NULL};

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_Delete,                  spawn,          		{.v = rofipower } },
	{ MODKEYA,                      XK_Delete,                  spawn,          		{.v = nakedquit } },
	{ MODKEY,                       XK_Print,                   spawn,          		{.v = screenshot } },
	{ 0,                            XK_Print,                   spawn,          		{.v = screenshotfull } },
	{ MODKEY,                       XK_F12,                     spawn,          		{.v = screenrecord } },
	{ MODKEY,                       XK_t,                       spawn,          		{.v = tabbed } },
	{ MODKEY,                       XK_n,                       spawn,          		{.v = combinemenu } },
	{ MODKEY,                       XK_m,                       spawn,          		{.v = mocp } },
    { MODKEY,                       XK_space,                   togglefloating,			{0} },		
	{ MODKEY,                       XK_End,                     quit,      			    {0} },
	{ MODKEY,                       XK_Tab,                     view,           		{0} },

    // { MODKEY,                       XK_q,                       shiftviewclients, 		{.i = +1 } },
	{ MODKEY,                       XK_w,                       cyclelayout,    		{.i = +1 } },
	{ MODKEY,                       XK_e,                       incnmaster,     		{.i = +1 } },

	{ MODKEY,                       XK_a,                       focusstack,     		{.i = +1 } },
    { MODKEY,                       XK_d,                       spawn,          		{.v = termcmd } },
	{ MODKEY,                       XK_f,                       togglefullscr,  		{0} },

    { MODKEY,                       XK_z,                       zoom,       			{0} },
    { MODKEY,                       XK_x,                       killclient,     		{0} },
    { MODKEY,                       XK_c,                       spawn,          		{.v = rofi } },
    { MODKEY,                       XK_v,                       spawn,          		{.v = dmenucmd } },
    { MODKEY,                       XK_p,                       spawn,          		{.v = popmenu } },
	{ MODKEY,                       XK_b,                       togglebar,      		{0} },

    { MODKEY,                       XK_y,                       spawn,          		{.v = clipmenu } },

    { MODKEY,                       XK_Left,                    focusstack,     		{.i = -1 } },
    { MODKEY,                       XK_Right,                   focusstack,     		{.i = +1 } },
    { MODKEY,                       XK_Up,                      setmfact,       		{.f = -0.05 } },
    { MODKEY,                       XK_Down,                    setmfact,       		{.f = +0.05 } },
	// { MODKEY,	            	    XK_F1,                      tagmon,     			{.i = -1 } },
	// { MODKEY,                       XK_z,                       focusmon,   			{.i = -1 } },

	{ MODKEY|Mod1Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_0,      togglegaps,     {0} },
	{ MODKEY|Mod1Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	TAGKEYS(XK_1, 0)
	TAGKEYS(XK_2, 1)
	TAGKEYS(XK_3, 2)
	TAGKEYS(XK_4, 3)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            0,              Button1,        view,           		{0} },
	{ ClkStatusText,        0,            	Button1,        spawn,          		{.v = rofi } },
	{ ClkStatusText,        0,            	Button3,        spawn,          		{.v = rofi } },
	{ ClkWinTitle,          0,              Button1,        spawn,          		{.v = rofi } },	
	{ ClkWinTitle,          0,              Button3,        zoom,           		{0} },
	{ ClkRootWin,        	0,              Button1,        spawn,          		{.v = rofi } },	
	{ ClkRootWin,        	0,              Button3,        spawn,          		SHCMD("pcmanfm") },
	{ ClkLtSymbol,        	0,              Button1,        cyclelayout,    		{.i = +1 } },
	{ ClkClientWin,         MODKEY,        	Button1,        movemouse,      		{0} },
	{ ClkClientWin,         MODKEY,        	Button3,        resizemouse,    		{0} },
	
};

