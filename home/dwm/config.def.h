/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx       = 1;         /* border pixel of windows */
static const unsigned int snap           = 20;        /* snap pixel */
static const unsigned int gappih         = 8;         /* horiz inner gap between windows */
static const unsigned int gappiv         = 8;         /* vert inner gap between windows */
static const unsigned int gappoh         = 7;         /* horiz outer gap between windows and screen edge */
static const unsigned int gappov         = 10;        /* vert outer gap between windows and screen edge */
static       int smartgaps               = 0;         /* 1 means no outer gap when there is only one window */
static const unsigned int systraypinning = 0;         /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;         /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;         /* systray spacing */
static const unsigned int systrayheight  = 19;        /* systray height */
static const int          systraylpad    = 0;         /* systray left padding, -1 = auto (lrpad/2) */
static const int          systrayrpad    = 2;         /* systray right padding, -1 = auto (lrpad/2) */
static const int systraypinningfailfirst = 1;         /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int swallowfloating         = 0;         /* 1 means swallow floating windows by default */
static const int showsystray             = 1;         /* 0 means no systray */
static const int showbar                 = 1;         /* 0 means no bar */
static const int topbar                  = 1;         /* 0 means bottom bar */
static const int focusonwheel            = 0;
static const int user_bh                 = 23;        /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const int statuslpad              = -1;        /* status text left padding, -1 = auto (lrpad/2) */
static const int statusrpad              = 2;         /* status text right padding, -1 = auto (lrpad/2) */
static const int statustpad              = 1;         /* status text top padding */
static const int windowtitletpad         = 1;         /* window title top padding */
static const int layoutlpad              = -4;        /* layout left padding */
static const int layouttpad              = -1;        /* layout top padding */
static const int attachmode              = 4;         /* default attach mode: 0 = dwm/top, 1 = below, 2 = above, 3 = bottom, 4 = aside */
#define ICONSIZE    17                                /* icon size */
#define ICONSPACING 5                                 /* space between icon and title */
#define SHOWWINICON 0                                 /* 0 means no winicon */

static const char *fonts[]          = {
    "FiraCode Nerd Font:style=Regular:pixelsize=16:antialias=true:autohint=true",                            /* tags, layout */
    "FiraCode Nerd Font:style=Regular:pixelsize=16:antialias=true:autohint=true",                            /* status monitor */
    "FiraCode Nerd Font:style=Regular:pixelsize=16:antialias=true:autohint=true",                            /* window titles */
    "FiraCode Nerd Font:style=Regular:pixelsize=16:antialias=true:autohint=true",                            /* cjk font */
    // "Symbola:size=13.5:antialias=true",                                                                    /* outline emojis */
    "Noto Color Emoji:size=10:antialias=true:autohint=true"                                                /* color emojis */
};

const int enablecolorfonts          = 1;  /* color fonts require libxft 2.3.5 or newer */
const int removevs16codepoints      = 1;  /* remove VS15, VS16 and zero-width-joiner codepoints/glyphs from emojis */

#define NOTIFYFONT                    "FiraCode Nerd Font:style=Regular:pixelsize=19:antialias=true:autohint=true"
static const char dmenufont[]       = "FiraCode Nerd Font:style=Regular:pixelsize=19:antialias=true:autohint=true";
static const char dmenuheight[]     = "23";

#include "themes/one-white.h"

/* color schemes */
enum { SchemeNorm,
       SchemeCol1,  SchemeCol2,  SchemeCol3,  SchemeCol4, SchemeCol5,
       SchemeCol6,  SchemeCol7,  SchemeCol8,  SchemeCol9, SchemeCol10,
       SchemeCol11, SchemeCol12, SchemeCol13,
       SchemeSel,   SchemeSel1,  SchemeTitle, SchemeTitleSel,
       SchemeHid,   SchemeHidSel };

static const char *colors[][3]      = {
	/*               fg           bg           border   */
	[SchemeNorm]     = { normfgcolor,      normbgcolor,      normbordercolor },
	[SchemeCol1]     = { col1,             normbgcolor,      normbordercolor },
	[SchemeCol2]     = { col2,             normbgcolor,      normbordercolor },
	[SchemeCol3]     = { col3,             normbgcolor,      normbordercolor },
	[SchemeCol4]     = { col4,             normbgcolor,      normbordercolor },
	[SchemeCol5]     = { col5,             normbgcolor,      normbordercolor },
	[SchemeCol6]     = { col6,             normbgcolor,      normbordercolor },
	[SchemeCol7]     = { col7,             normbgcolor,      normbordercolor },
	[SchemeCol8]     = { col8,             normbgcolor,      normbordercolor },
	[SchemeCol9]     = { col9,             normbgcolor,      normbordercolor },
	[SchemeCol10]    = { col10,            normbgcolor,      normbordercolor },
	[SchemeCol11]    = { col11,            normbgcolor,      normbordercolor },
	[SchemeCol12]    = { col12,            normbgcolor,      normbordercolor },
	[SchemeCol13]    = { col13,            normbgcolor,      normbordercolor },
	[SchemeSel]      = { selfgcolor,       selbgcolor,       selbordercolor  },
	[SchemeSel1]     = { selfgcolor,       selbgcolor,       selbordercolor1 },
	[SchemeTitle]    = { titlenormfgcolor, titlenormbgcolor, normbordercolor },
	[SchemeTitleSel] = { titleselfgcolor,  titleselbgcolor,  normbordercolor },
	[SchemeHid]      = { hiddencolor,      titlenormbgcolor, hiddencolor     },
	[SchemeHidSel]   = { hiddenselcolor,   titleselbgcolor,  hiddenselcolor  },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"st", "-A", "0.95", "-n", "spterm", "-g", "124x34", NULL };
const char *spcmd2[] = {"st", "-A", "0.95", "-n", "spterm", "-g", "142x42", "-e", "yazi", NULL };
const char *spcmd3[] = {"pavucontrol", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",      spcmd1},
	{"splf",        spcmd2},
	{"spcalc",      spcmd3},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const char *tagsalt[] = { "", "", "", "", "", "", "", "", "" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                instance   title        tags mask    switchtotag    isfloating  isterminal  noswallow  monitor */
	{ NULL,                 NULL,      "LibreOffice", 1 << 3,        1,            0,           0,        1,          -1 },
	{ NULL,                 NULL,      "Soffice",     1 << 3,        1,            0,           0,        1,          -1 },
	{ NULL,                 "soffice", NULL,          1 << 3,        1,            0,           0,        1,          -1 },
	{ "Pcmanfm",             NULL,      NULL,          1 << 2,        1,            0,           0,        1,          -1 },
	{ "Gimp",               NULL,      NULL,          1 << 5,        1,            0,           0,        1,          -1 },
	{ "firefox",            NULL,      NULL,               0,        0,            0,           0,        1,          -1 },
	{ "Chromium",           NULL,      NULL,               0,        0,            0,           0,        1,          -1 },
	{ "mpv",                NULL,      NULL,               0,        0,            0,           0,        0,          -1 },
	{ "St",                 NULL,      NULL,               0,        0,            0,           1,        0,          -1 },
	{ NULL,                 NULL,     "Event Tester",      0,        0,            0,           0,        1,          -1 }, /* xev */
	{ "Dragon-drop",        NULL,      NULL,               0,        0,            1,           0,        1,          -1 },
	{ "Pinentry-gtk-2",     NULL,      NULL,               0,        0,            1,           0,        1,          -1 },
	{ "Gnome-calculator",   NULL,      NULL,               0,        0,            1,           0,        0,          -1 },
	{ "Galculator",         NULL,      NULL,               0,        0,            1,           0,        0,          -1 },
	{ "pavucontrol",        NULL,      NULL,               0,        0,            1,           0,        0,          -1 },
	{ "flameshot",          NULL,      NULL,               0,        0,            1,           0,        0,          -1 },
	{ "Yad",                NULL,      NULL,               0,        0,            1,           0,        0,          -1 },
	{ NULL,                 "spterm",  NULL,         SPTAG(0),       0,            1,           0,        0,          -1 },
	{ NULL,                 "spfm",    NULL,         SPTAG(1),       0,            1,           0,        0,          -1 },
	{ "Qalculate",          NULL,      NULL,         SPTAG(2),       0,            1,           0,        0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

struct Pertag {
	unsigned int curtag, prevtag; /* current and previous tag */
	int nmasters[LENGTH(tags) + 1]; /* number of windows in master area */
	float mfacts[LENGTH(tags) + 1]; /* mfacts per tag */
	unsigned int sellts[LENGTH(tags) + 1]; /* selected layouts */
	const Layout *ltidxs[LENGTH(tags) + 1][2]; /* matrix of tags and layouts indexes  */
	int showbars[LENGTH(tags) + 1]; /* display bar for the current tag */
	/* custom */
	unsigned int selatts[LENGTH(tags) + 1]; /* selected attach positions */
	const Attach *attidxs[LENGTH(tags) + 1][2]; /* matrix of tags and attach positions indexes */
	int enablegaps[LENGTH(tags) + 1]; /* vanitygaps */
	unsigned int gaps[LENGTH(tags) + 1]; /* vanitycaps */
	Client *prevzooms[LENGTH(tags) + 1]; /* zoomswap */
};
#define PERTAG_PATCH 1
#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"
#include "inplacerotate.c"

enum {
	LayoutTile,
	LayoutMonocle,
	LayoutSpiral,
	LayoutDwindle,
	LayoutDeck,
	LayoutBstack,
	LayoutBstackhoriz,
	LayoutGrid,
	LayoutNrowgrid,
	LayoutHorizgrid,
	LayoutGaplessgrid,
	LayoutCenteredmaster,
	LayoutCenteredfloatingmaster,
	LayoutFloat
};

typedef struct {
	int tag;      /* tag number */
	int layout;   /* layout */
	float mfact;  /* master / stack factor */
	int gappih;   /* horizontal gap between windows */
	int gappiv;   /* vertical gap between windows */
	int gappoh;   /* horizontal outer gaps */
	int gappov;   /* vertical outer gaps */
} TagRule;

static const TagRule tagrules[] = {
	{ 4, LayoutTile, 0.5,  0,0,0,0 },
};

static const Layout layouts[] = {
	/* symbol   arrange function */
	{ "[]=",    tile },    /* first entry is default */
	{ "[M]",    monocle },
	{ "[@]",    spiral },
	{ "[\\]",   dwindle },
	{ "[D]",    deck },
	{ "TTT",    bstack },
	{ "===",    bstackhoriz },
	{ "HHH",    grid },
	{ "###",    nrowgrid },
	{ "---",    horizgrid },
	{ ":::",    gaplessgrid },
	{ "|M|",    centeredmaster },
	{ ">M>",    centeredfloatingmaster },
	{ "><>",    NULL },    /* no layout function means floating behavior */
	{ NULL,     NULL },
};

static const Attach attachs[] = {
	/* symbol   attach function */
	{ "",      attach },
	{ "",      attachbelow },
	{ "",      attachabove },
	{ "",      attachbottom },
	{ "",      attachaside },
};

/* key definitions */
#define Alt    Mod1Mask
#define AltGr  Mod5Mask
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2]                = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]          = { "dmenu_run", NULL };
static const char *attachmenucmd       = "dwm-attachmenu";
static const char *layoutmenucmd       = "dwm-layoutmenu";
static const char *vivaldi[]           = { "vivaldi-stable", NULL };
static const char *firefox[]           = { "firefox", NULL };
static const char *filemanager[]       = { "pcmanfm", NULL };
static const char *rofipowercmd[]      = { "rofi", "-show", "p", "-modi", "p:~/.local/bin/rofi-power-menu", "-me-select-entry", "", "-me-accept-entry", "MousePrimary", "-no-show-icons",  NULL };
static const char *rofilauncher[]      = { "/home/hudamnhd/.local/bin/rofi-custom", NULL };
static const char *pavucontrolcmd[]    = { "pavucontrol", NULL};
static const char *rofiemoji[]         = { "/home/hudamnhd/.local/bin/rofi-emoji", NULL };
static const char *terminal[]          = { "st", NULL };
static const char *volumeup[]          = { "/home/hudamnhd/.dwm/scripts/vol-up.sh",  NULL };
static const char *volumedown[]        = { "/home/hudamnhd/.dwm/scripts/vol-down.sh",  NULL };
static const char *mute[]              = { "/home/hudamnhd/.dwm/scripts/vol-toggle.sh",  NULL };
static const char *mocp[]              = { "/home/hudamnhd/.local/bin/mocp.sh", NULL};
static const char *screenshotcmd[]     = { "/home/hudamnhd/.local/bin/screenshot", NULL};
static const char *screenshotfullcmd[] = { "/home/hudamnhd/.local/bin/screenshot-full", NULL};
static const char *screenrecordcmd[]   = { "/home/hudamnhd/.local/bin/screenrecord", NULL};
static const char *xkbswitchcmd[]      = { "/home/hudamnhd/.local/bin/xkb-switch.sh", NULL};

#include <X11/XF86keysym.h>
static const Key keys[] = {
	/* modifier                     key              function            argument */
    { 0,                            XK_Print,        spawn,              {.v = screenshotfullcmd } },
    { MODKEY,                       XK_Print,        spawn,              {.v = screenshotcmd } },
	{ MODKEY,                       XK_Delete,       spawn,              {.v = rofipowercmd } },
	{ MODKEY,                       XK_F12,          spawn,              {.v = screenrecordcmd } },
	{ MODKEY,                       XK_F11,          spawn,              {.v = xkbswitchcmd } },
    { MODKEY,                       XK_m,            spawn,              {.v = mocp } },
    { MODKEY,                       XK_s,            spawn,              {.v = rofilauncher } },
    { MODKEY|ShiftMask,             XK_s,            spawn,              {.v = rofiemoji } },
    { MODKEY,                       XK_t,            spawn,              SHCMD("tabbed -r 2 st -w '' -e")},
    { MODKEY|ShiftMask,             XK_t,            spawn,              SHCMD("st -e tmux")},
    { MODKEY,                       XK_y,            spawn,              SHCMD("st -e bash -i -c 'yy; exec bash'") },
    { MODKEY,                       XK_p,            spawn,              {.v = dmenucmd } },
	{ MODKEY,                       XK_d,            spawn,              {.v = terminal } },
    { MODKEY,                       XK_c,            spawn,              {.v = filemanager } },
	{ MODKEY,                       XK_v,            spawn,              {.v = vivaldi } },
	{ MODKEY,                       XK_b,            spawn,              {.v = firefox } },
	{ MODKEY|ShiftMask,             XK_b,            togglebar,          {0} },

    { MODKEY,                       XK_a,            focusstackvis,      {.i = +1 } },
    { MODKEY,                       XK_i,            focusstackvis,      {.i = -1 } },
    { MODKEY|Alt,                   XK_a,            pushclient,         {.i = +1 } },
    { MODKEY|Alt,                   XK_i,            pushclient,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_a,            focusstackhid,      {.i = +1} },
    { MODKEY|ShiftMask,             XK_i,            focusstackhid,      {.i = -1} },
	{ MODKEY,                       XK_h,            left_or_master,     {0} },
	{ MODKEY,                       XK_l,            right_or_stack,     {0} },
    { MODKEY|ShiftMask,             XK_h,            inplacerotate,      {.i = -1} },
    { MODKEY|ShiftMask,             XK_l,            inplacerotate,      {.i = +1} },
    { MODKEY|ShiftMask|ControlMask, XK_h,            inplacerotate,      {.i = -2} },
    { MODKEY|ShiftMask|ControlMask, XK_l,            inplacerotate,      {.i = +2} },
    { MODKEY,                       XK_Down,         focusdir,           {.i = 3 } }, // down
    { MODKEY,                       XK_Up,           focusdir,           {.i = 2 } }, // up
	{ MODKEY,                       XK_Right,        focusdir,           {.i = 1 } }, // right
    { MODKEY,                       XK_Left,         focusdir,           {.i = 0 } }, // left
	{ MODKEY|ShiftMask,             XK_Down,         moveresize,         {.v = "0x 25y 0w 0h" } },
	{ MODKEY|ShiftMask,             XK_Up,           moveresize,         {.v = "0x -25y 0w 0h" } },
	{ MODKEY|ShiftMask,             XK_Right,        moveresize,         {.v = "25x 0y 0w 0h" } },
	{ MODKEY|ShiftMask,             XK_Left,         moveresize,         {.v = "-25x 0y 0w 0h" } },
    { MODKEY|ControlMask|ShiftMask, XK_Down,         moveresizeedge,     {.v = "b"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Up,           moveresizeedge,     {.v = "t"} },
    { MODKEY|ControlMask|ShiftMask, XK_Right,        moveresizeedge,     {.v = "r"} },
	{ MODKEY|ControlMask|ShiftMask, XK_Left,         moveresizeedge,     {.v = "l"} },
    { MODKEY|Alt,                   XK_Down,         aspectresize,       {.i = +25} },
	{ MODKEY|Alt,                   XK_Up,           aspectresize,       {.i = -25} },
    { MODKEY|Alt,                   XK_Right,        aspectresize,       {.i = +25} },
	{ MODKEY|Alt,                   XK_Left,         aspectresize,       {.i = -25} },
	{ MODKEY|ControlMask,           XK_Down,         moveresize,         {.v = "0x 0y 0w 25h" } },
	{ MODKEY|ControlMask,           XK_Up,           moveresize,         {.v = "0x 0y 0w -25h" } },
	{ MODKEY|ControlMask,           XK_Right,        moveresize,         {.v = "0x 0y 25w 0h" } },
	{ MODKEY|ControlMask,           XK_Left,         moveresize,         {.v = "0x 0y -25w 0h" } },
/*
	{ MODKEY|ControlMask|Alt, XK_Up,     moveresizeedge, {.v = "T"} },
	{ MODKEY|ControlMask|Alt, XK_Down,   moveresizeedge, {.v = "B"} },
	{ MODKEY|ControlMask|Alt, XK_Left,   moveresizeedge, {.v = "L"} },
	{ MODKEY|ControlMask|Alt, XK_Right,  moveresizeedge, {.v = "R"} },
*/
	{ MODKEY,                       XK_bracketright,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_bracketleft,       incnmaster,     {.i = -1 } },

	{ MODKEY|ControlMask,           XK_h,                 setmfact,       {.f = -0.05} },
	{ MODKEY|ControlMask,           XK_l,                 setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_j,                 setcfact,       {.f = -0.25} },
	{ MODKEY|ControlMask,           XK_k,                 setcfact,       {.f = +0.25} },
	{ MODKEY|ControlMask,           XK_n,                 setcfact,       {.f =  0.00} },

	{ MODKEY|ShiftMask,             XK_Return,            zoom,           {0} },
	{ MODKEY,                       XK_Return,            zoomswap,       {0} },

	{ MODKEY,                       XK_bracketright,      incrgaps,       {.i = +2 } },
	{ MODKEY,                       XK_bracketleft,       incrgaps,       {.i = -2 } },
	{ MODKEY|ShiftMask,             XK_BackSpace,         defaultgaps,    {0} },
    { MODKEY,                       XK_BackSpace,         togglegaps,     {0} },
/*
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

	{ Alt,                          XK_Tab,    shiftviewclients, {.i = +1} },
	{ Alt|ShiftMask,                XK_Tab,    shiftviewclients, {.i = -1} },
*/

    { MODKEY,                       XK_x,                  killclient,     {0} },

    { Alt,                          XK_Tab,                swapfocus,      {0} },
    { MODKEY,                       XK_Tab,                view,           {0} },
	{ MODKEY,                       XK_e,                  setlayout,      {.v = &layouts[LayoutTile]} },
	{ MODKEY|ShiftMask,             XK_e,                  setlayout,      {.v = &layouts[LayoutBstack]} },
	{ MODKEY,                       XK_r,                  setlayout,      {.v = &layouts[LayoutNrowgrid]} },
	{ MODKEY,                       XK_w,                  setlayout,      {.v = &layouts[LayoutMonocle]} },
	{ MODKEY|ShiftMask,             XK_w,                  setlayout,      {.v = &layouts[LayoutDeck]} },
	{ MODKEY|ShiftMask,             XK_c,                  setlayout,      {.v = &layouts[LayoutCenteredmaster]} },
    { MODKEY,                       XK_space,              togglefloating, {.i = 1 } },
    { MODKEY|ShiftMask,             XK_space,              setlayout,      {.v = &layouts[LayoutFloat]} },
	{ MODKEY,                       XK_F1,                 cycleattach,    {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_F1,                 cycleattach,    {.i = -1 } },
	{ MODKEY,                       XK_f,                  togglefullscreen, {0} },
	{ MODKEY|ControlMask,           XK_f,                  togglefakefullscreen, {0} },
	{ MODKEY,                       XK_0,                  view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,                  tag,            {.ui = ~0 } },

    { MODKEY,                       XK_comma,              cyclelayout,    {.i = -1 } },
    { MODKEY,                       XK_period,             cyclelayout,    {.i = +1 } },
    { MODKEY,                       XK_n,                  togglealttag,   {0} },
    { MODKEY,                       XK_minus,              hide,           {0} },
    { MODKEY,                       XK_equal,              show,           {0} },
    { MODKEY,                       XK_q,                  togglesticky,   {0} },
    { MODKEY|ShiftMask,             XK_q,                  togglescratch,  {.ui = 0 } },
    // dual monitor
	// { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	// { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	// { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	// { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	// { MODKEY,                       XK_e,      togglescratch,  {.ui = 1 } },
	// { MODKEY,                       XK_c,      togglescratch,  {.ui = 2 } },
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
	/* click                event mask          button      function        argument */
	{ ClkAttSymbol,         0,                  Button1,    setattach,      {0} },
	{ ClkAttSymbol,         0,                  Button3,    attachmenu,     {0} },
	{ ClkLtSymbol,          0,                  Button1,    setlayout,      {0} },
	{ ClkLtSymbol,          0,                  Button3,    layoutmenu,     {0} },
	{ ClkWinTitle,          0,                  Button1,    togglewin,      {0} },
	{ ClkWinTitle,          0,                  Button3,    show,           {0} },
	{ ClkWinTitle,          0,                  Button2,    zoom,           {0} },
	{ ClkClientWin,         MODKEY,             Button1,    movemouse,      {0} },
	{ ClkClientWin,         MODKEY,             Button2,    togglefloating, {0} },
	{ ClkClientWin,         MODKEY,             Button3,    resizemouse,    {0} },
	{ ClkClientWin,         Alt,                Button1,    dragmfact,      {0} },
	{ ClkClientWin,         Alt,                Button3,    dragcfact,      {0} },
    { ClkRootWin,           Alt,                Button1,    dragmfact,      {0} },
    { ClkClientWin,         MODKEY,             Button4,    focusstackvis,      {.i = +1 } },
    { ClkClientWin,         MODKEY,             Button5,    focusstackvis,      {.i = -1 } },
	{ ClkTagBar,            0,                  Button1,    view,           {0} },
	{ ClkTagBar,            0,                  Button3,    toggleview,     {0} },
	{ ClkTagBar,            MODKEY,             Button1,    tag,            {0} },
	{ ClkTagBar,            MODKEY,             Button3,    toggletag,      {0} },
	{ ClkStatusText,        0,                  Button1,    spawn,          {.v = rofilauncher } },
	{ ClkStatusText,        0,                  Button3,    spawn,          {.v = pavucontrolcmd } },
};

/* signal functions */
void
restart(const Arg *arg)
{
	quit(&((Arg){.i = EXIT_RESTART}));
}

void
poweroff(const Arg *arg)
{
	quit(&((Arg){.i = EXIT_POWEROFF}));
}

void
reboot(const Arg *arg)
{
	quit(&((Arg){.i = EXIT_REBOOT}));
}

void
refreshsystrayhandler(const Arg *arg)
{
	systraytimer = 0;
	refreshsystray();
}

/* signal definitions */
/* signum must be greater than 0 */
/* trigger signals using `xsetroot -name "fsignal:<signame> [<type> <value>]"` */
static Signal signals[] = {
	/* signum           function */
	{ "quit",           quit },
	{ "restart",        restart },
	{ "poweroff",       poweroff },
	{ "reboot",         reboot },
	{ "refreshsystray", refreshsystrayhandler },
};
