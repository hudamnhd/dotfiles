/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrainsMono Nerd Font Mono:size=10:style=Medium" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font Mono:size=10:style=Medium";
static const char col_gray1[]       = "#17171b";
static const char col_gray2[]       = "#6b7089";
static const char col_gray3[]       = "#c6c8d1";
static const char col_gray4[]       = "#818596";
static const char col_cyan[]        = "#444b71";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray1 },
	[SchemeSel]  = { col_gray1, col_gray4,  col_gray4 },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" };
// static const char *tags[] = { "", "", "", "", "", "", "", "", "" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class            instance    title       tags mask     isfloating   monitor */
	{ "firefox",        NULL,       NULL,       1 << 0,       0,           -1 },
	{ "Vivaldi-stable", NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Pcmanfm",        NULL,       NULL,       1 << 2,       0,           -1 },
	{ "Pavucontrol",    NULL,       NULL,       1 << 3,       1,           -1 },
	{ "mpv",            NULL,       NULL,       1 << 4,       0,           -1 },
	{ "Zathura",        NULL,       NULL,       1 << 5,       0,           -1 },
	{ "Mousepad",       NULL,       NULL,       1 << 8,       0,           -1 },

};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#include "grid.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "HHH",      grid },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *pavucmd[]  = { "pavucontrol", NULL};
static const char *roficmd[]  = { "/home/hudamnhd/.local/bin/rofi-custom", "menu", NULL };

static const Key keys[] = {
	/* modifier                           key              function        argument */
	{ MODKEY,                             XK_p,            spawn,          {.v = roficmd } },
	{ MODKEY,                             XK_x,            spawn,          {.v = termcmd } },
	{ MODKEY,                             XK_b,            togglebar,      {0} },
	{ MODKEY,                             XK_j,            focusstack,     {.i = +1 } },
	{ MODKEY,                             XK_k,            focusstack,     {.i = -1 } },
	{ MODKEY,                             XK_a,            focusstack,     {.i = +1 } },
	{ MODKEY,                             XK_i,            focusstack,     {.i = -1 } },
	{ MODKEY,                             XK_bracketleft,  incnmaster,     {.i = +1 } },
	{ MODKEY,                             XK_bracketright, incnmaster,     {.i = -1 } },
	{ MODKEY,                             XK_h,            setmfact,       {.f = -0.05} },
	{ MODKEY,                             XK_l,            setmfact,       {.f = +0.05} },
	{ MODKEY,                             XK_Return,       zoom,           {0} },
	{ MODKEY,                             XK_Tab,          view,           {0} },
	{ MODKEY,                             XK_q,            killclient,     {0} },
	{ MODKEY,                             XK_w,            togglelayout,   {0} },
	{ MODKEY,                             XK_f,            setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                             XK_g,            setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                             XK_space,        setlayout,      {0} },
	{ MODKEY|ShiftMask,                   XK_space,        togglefloating, {0} },
	{ MODKEY,                             XK_v,            view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,                   XK_v,            tag,            {.ui = ~0 } },
	// { MODKEY,                             XK_comma,        focusmon,       {.i = -1 } },
	// { MODKEY,                             XK_period,       focusmon,       {.i = +1 } },
	// { MODKEY|ShiftMask,                   XK_comma,        tagmon,         {.i = -1 } },
	// { MODKEY|ShiftMask,                   XK_period,       tagmon,         {.i = +1 } },
	TAGKEYS(                              XK_1,                             0)
	TAGKEYS(                              XK_2,                             1)
	TAGKEYS(                              XK_3,                             2)
	TAGKEYS(                              XK_4,                             3)
	TAGKEYS(                              XK_5,                             4)
	TAGKEYS(                              XK_6,                             5)
	TAGKEYS(                              XK_7,                             6)
	TAGKEYS(                              XK_8,                             7)
	TAGKEYS(                              XK_9,                             8)
	TAGKEYS(                              XK_0,                             9)
	{ MODKEY|ShiftMask,                   XK_q,            quit,           {0} },
  { MODKEY,                             XK_minus,        hidewin,        {0} },
  { MODKEY,                             XK_equal,        restorewin,     {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        togglelayout,   {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[3]} },
	{ ClkStatusText,        0,              Button1,        spawn,          {.v = roficmd } },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkStatusText,        0,              Button3,        spawn,          {.v = pavucmd } },
	{ ClkWinTitle,          0,              Button1,        spawn,          {.v = roficmd } },
	{ ClkWinTitle,          0,              Button3,        zoom,           {0} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkClientWin,         MODKEY,         Button4,        focusstack,     {.i = +1 } },
	{ ClkClientWin,         MODKEY,         Button5,        focusstack,     {.i = -1 } },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

