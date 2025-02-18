/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrainsMono NF Medium:style=Medium:size=10:antialias=true:autohint=true" };
static const char dmenufont[]       = "JetBrainsMono NF Medium:style=Medium:size=10:antialias=true:autohint=true";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
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
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
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
static const char *dmenucmd[]        = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]         = { "st", NULL };
static const char *vivaldi[]         = { "vivaldi-stable", NULL };
static const char *firefox[]         = { "firefox", NULL };
static const char *filemanager[]     = { "pcmanfm", NULL };
static const char *rofipowercmd[]    = { "rofi", "-show", "p", "-modi", "p:~/.local/bin/rofi-power-menu", "-me-select-entry", "", "-me-accept-entry", "MousePrimary", "-no-show-icons",  NULL };
static const char *rofilauncher[]    = { "/home/hudamnhd/.local/bin/rofi-custom", NULL };
static const char *pavucontrolcmd[]  = { "pavucontrol", NULL};
static const char *rofiemoji[]       = { "/home/hudamnhd/.local/bin/rofi-emoji", NULL };
static const char *terminal[]        = { "st", NULL };
static const char *volumeup[]        = { "/home/hudamnhd/.dwm/scripts/vol-up.sh",  NULL };
static const char *volumedown[]      = { "/home/hudamnhd/.dwm/scripts/vol-down.sh",  NULL };
static const char *mute[]            = { "/home/hudamnhd/.dwm/scripts/vol-toggle.sh",  NULL };
static const char *mocp[]            = { "/home/hudamnhd/.local/bin/mocp.sh", NULL};
static const char *screenshotcmd[]   = { "/home/hudamnhd/.local/bin/screenshot", NULL};
static const char *screenshot2cmd[]  = { "/home/hudamnhd/.local/bin/screenshot-full", NULL};
static const char *screenrecordcmd[] = { "/home/hudamnhd/.local/bin/screenrecord", NULL};
static const char *xkbswitchcmd[]    = { "/home/hudamnhd/.local/bin/xkb-switch.sh", NULL};

static const Key keys[] = {
	/* modifier                     key				 function        argument */
    { 0,                            XK_Print,        spawn,          {.v = screenshot2cmd } },
    { MODKEY,                       XK_Print,        spawn,          {.v = screenshotcmd } },
	{ MODKEY,                       XK_Delete,       spawn,          {.v = rofipowercmd } },
	{ MODKEY,                       XK_F12,          spawn,          {.v = screenrecordcmd } },
	{ MODKEY,                       XK_F11,          spawn,          {.v = xkbswitchcmd } },
    { MODKEY,                       XK_m,            spawn,          {.v = mocp } },
    { MODKEY,                       XK_s,            spawn,          {.v = rofilauncher } },
    { MODKEY|ShiftMask,             XK_s,            spawn,          {.v = rofiemoji } },
    { MODKEY,                       XK_t,            spawn,          SHCMD("tabbed -r 2 st -w '' -e")},
    { MODKEY|ShiftMask,             XK_t,            spawn,          SHCMD("st -e tmux")},
    { MODKEY,                       XK_y,            spawn,          SHCMD("st -e bash -i -c 'yy; exec bash'") },
	{ MODKEY,                       XK_d,            spawn,          {.v = terminal } },
    { MODKEY,                       XK_c,            spawn,          {.v = filemanager } },
	{ MODKEY,                       XK_v,            spawn,          {.v = vivaldi } },
	{ MODKEY,                       XK_b,            spawn,          {.v = firefox } },
	{ MODKEY|ShiftMask,             XK_b,            togglebar,      {0} },
	{ MODKEY,                       XK_p,            spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_a,            focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_i,            focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_bracketright, incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_bracketleft,  incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,            setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,            setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return,       zoom,           {0} },
	{ MODKEY,                       XK_Tab,          view,           {0} },
	{ MODKEY,                       XK_x,            killclient,     {0} },
	{ MODKEY,                       XK_e,            setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,            setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_w,            setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,        togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_space,        setlayout,      {0} },
	{ MODKEY,                       XK_0,            view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,            tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,        focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,       focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,        tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,       tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkRootWin,			0,              Button1,		spawn,          {.v = rofilauncher } },
	{ ClkStatusText,        0,              Button1,		spawn,          {.v = rofilauncher } },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkStatusText,        0,              Button3,		spawn,          {.v = pavucontrolcmd } },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
};
