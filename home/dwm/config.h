/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx       = 1;        /* border pixel of windows */
static const unsigned int snap           = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray             = 1;        /* 0 means no systray */
static const unsigned int gappih         = 20;       /* horiz inner gap between windows */
static const unsigned int gappiv         = 10;       /* vert inner gap between windows */
static const unsigned int gappoh         = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov         = 30;       /* vert outer gap between windows and screen edge */
static       int smartgaps               = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar                 = 1;        /* 0 means no bar */
static const int topbar                  = 1;        /* 0 means bottom bar */
static const char *fonts[]               = { "IosevkaTree Nerd Font:style=SemiBold:pixelsize=14:antialias=true:autohint=true" };
static const char dmenufont[]            = "IosevkaTree Nerd Font:style=SemiBold:pixelsize=14:antialias=true:autohint=true";
static const char col_gray1[]            = "#222222";
static const char col_gray2[]            = "#444444";
static const char col_gray3[]            = "#bbbbbb";
static const char col_gray4[]            = "#eeeeee";
static const char col_cyan[]             = "#005577";
static const char *colors[][3]           = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_gray4 },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
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
#define MODKEY Mod4Mask	
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ ALTKEY,                       KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]       = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]        = { "alacritty", NULL };
static const char *rofi[]           = { "/home/hudamnhd/.local/bin/rofi-custom", NULL };
static const char *tabbed[]         = { "tabbed", "alacritty", "--embed", NULL };
static const char *volumedown[]     = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-10%", NULL };
static const char *volumeup[]       = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+10%", NULL };
static const char *mute[]           = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };
static const char *rofipower[]      = { "rofi", "-show", "p", "-modi", "p:~/.local/bin/rofi-power-menu", "-me-select-entry", "", "-me-accept-entry", "MousePrimary",  NULL };
static const char *nakedquit[]      = { "nakedquit",  NULL };
static const char *popmenu[]        = { "popmenu", "0",  NULL };
static const char *combinemenu[]    = { "combinemenu",  NULL };
static const char *mocp[]           = { "/home/hudamnhd/.local/bin/mocp.sh", NULL};
static const char *screenshot[]     = { "/home/hudamnhd/.local/bin/screenshot", NULL};
static const char *screenshotfull[] = { "/home/hudamnhd/.local/bin/screenshot-full", NULL};
static const char *screenrecord[]   = { "/home/hudamnhd/.local/bin/screenrecord", NULL};

static const Key keys[] = {
	/* modifier                     key                         function                argument */

	{ MODKEY,                  XK_Delete,       spawn,          {.v = rofipower } },
	{ ALTKEY,                  XK_Delete,       spawn,          {.v = nakedquit } },
	{ MODKEY,                  XK_Print,        spawn,          {.v = screenshot } },
	{ 0,                       XK_Print,        spawn,          {.v = screenshotfull } },
	{ MODKEY,                  XK_F12,          spawn,          {.v = screenrecord } },
	{ MODKEY,                  XK_F1,           spawn,          {.v = mocp } },
	{ MODKEY,                  XK_n,            spawn,          {.v = combinemenu } },
    { MODKEY,                  XK_space,        togglefloating, {0} },
	{ MODKEY,                  XK_End,          quit,           {0} },
	{ MODKEY,                  XK_Tab,          view,           {0} },

	{ MODKEY,                  XK_bracketleft,  incnmaster,     {.i = +1 } },
	{ MODKEY,                  XK_bracketright, incnmaster,     {.i = -1 } },

	{ MODKEY,                  XK_a,            focusstack,     {.i = +1 } },
    { MODKEY,                  XK_s,            spawn,          {.v = rofi } },
    { MODKEY,                  XK_d,            spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,        XK_d,            spawn,          {.v = tabbed } },

	{ MODKEY,                  XK_f,            setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                  XK_t,            setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                  XK_m,            setlayout,      {.v = &layouts[2]} },

    { MODKEY,                  XK_z,            zoom,           {0} },
    { MODKEY,                  XK_x,            killclient,     {0} },
	{ MODKEY,                  XK_c,            cyclelayout,    {.i = +1 } },
    { MODKEY,                  XK_v,            spawn,          {.v = dmenucmd } },
	{ MODKEY,                  XK_b,            togglebar,      {0} },

    { MODKEY,                  XK_p,            spawn,          {.v = popmenu } },

    { MODKEY,                  XK_Up,           setmfact,       {.f = -0.05 } },
    { MODKEY,                  XK_Down,         setmfact,       {.f = +0.05 } },
	{ MODKEY,                  XK_Left,         setcfact,       {.f = +0.25} },
	{ MODKEY,                  XK_Right,        setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,        XK_Down,         setcfact,       {.f =  0.00} },

	{ MODKEY|ALTKEY,           XK_u,            incrgaps,       {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_u,            incrgaps,       {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_i,            incrigaps,      {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_i,            incrigaps,      {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_o,            incrogaps,      {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_o,            incrogaps,      {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_6,            incrihgaps,     {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_6,            incrihgaps,     {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_7,            incrivgaps,     {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_7,            incrivgaps,     {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_8,            incrohgaps,     {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_8,            incrohgaps,     {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_9,            incrovgaps,     {.i = +1 } },
	{ MODKEY|ALTKEY|ShiftMask, XK_9,            incrovgaps,     {.i = -1 } },
	{ MODKEY|ALTKEY,           XK_0,            togglegaps,     {0} },
	{ MODKEY|ALTKEY|ShiftMask, XK_0,            defaultgaps,    {0} },

	/*
	{ MODKEY,                       XK_p,      spawn,          {.v = rofi } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|Mod4Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,      togglegaps,     {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ControlMask,		XK_comma,  cyclelayout,    {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, cyclelayout,    {.i = +1 } },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
      */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button1,        zoom,           {0} },
	{ ClkStatusText,        0,            	Button1,        spawn,          {.v = rofi } },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkStatusText,        0,            	Button3,        spawn,          SHCMD("pcmanfm") },
    { ClkStatusText,        0,              Button4,        spawn,          {.v = volumeup}},
    { ClkStatusText,        0,              Button5,        spawn,          {.v = volumedown}},
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkRootWin,        	0,              Button1,        spawn,          {.v = rofi } },	
	{ ClkRootWin,        	0,              Button3,        spawn,          SHCMD("pcmanfm") },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkLtSymbol,        	0,              Button1,        cyclelayout,    {.i = +1 } },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

