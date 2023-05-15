/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
#include "instantwm.h"

/* appearance */
static const unsigned int borderpx = 2;		  /* border pixel of windows */
static const unsigned int snap = 32;		  /* snap pixel */
static const unsigned int startmenusize = 30;		  /* snap pixel */
static const unsigned int systraypinning = 0; /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 0; /* systray spacing */
static const int systraypinningfailfirst = 0; /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray = 1;			  /* 0 means no systray */
static const int showbar = 1;				  /* 0 means no bar */
static const int topbar = 1;				  /* 0 means bottom bar */
static const char *fonts[] = { "JetBrains Mono ExtraBold:size=9" };

static int barheight;
static char xresourcesfont[30];

static char col_bg[] = "#121212";
static char col_text[] = "#DFDFDF";
static char col_black[] = "#000000";

static char col_bg_accent[] = "#384252";
static char col_bg_accent_hover[] = "#4C5564";
static char col_bg_hover[] = "#1C1C1C";

static char col_light_blue[] = "#89B3F7";
static char col_light_blue_hover[] = "#a1c2f9";
static char col_blue[] = "#536DFE";
static char col_blue_hover[] = "#758afe";


static char col_light_green[] = "#81c995";
static char col_light_green_hover[] = "#99d3aa";
static char col_green[] = "#1e8e3e";
static char col_green_hover[] = "#4ba465";

static char col_light_yellow[] = "#fdd663";
static char col_light_yellow_hover[] = "#fddd82";
static char col_yellow[] = "#f9ab00";
static char col_yellow_hover[] = "#f9bb33";

static char col_light_red[] = "#f28b82";
static char col_light_red_hover[] = "#f4a19a";
static char col_red[] = "#d93025";
static char col_red_hover[] = "#e05951";

static const char *tagcolors[2][5][3] = {
    [SchemeNoHover] = {
        [SchemeTagInactive] = {
            [ColFg] = col_text,
            [ColBg] = col_bg,
            [ColDetail] = col_bg,
        },
        [SchemeTagFilled] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_accent,
            [ColDetail] = col_light_blue,
        },
        [SchemeTagFocus] = {
            [ColFg] = col_black,
            [ColBg] = col_light_green,
            [ColDetail] = col_green,
        },
        [SchemeTagNoFocus] = {
            [ColFg] = col_black,
            [ColBg] = col_light_yellow,
            [ColDetail] = col_yellow,
        },
        [SchemeTagEmpty] = {
            [ColFg] = col_black,
            [ColBg] = col_light_red,
            [ColDetail] = col_red,
        }
    },
    [SchemeHover] = {
        [SchemeTagInactive] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_hover,
            [ColDetail] = col_bg,
        },
        [SchemeTagFilled] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_accent_hover,
            [ColDetail] = col_light_blue_hover,
        },
        [SchemeTagFocus] = {
            [ColFg] = col_black,
            [ColBg] = col_light_green_hover,
            [ColDetail] = col_green_hover,
        },
        [SchemeTagNoFocus] = {
            [ColFg] = col_black,
            [ColBg] = col_light_yellow_hover,
            [ColDetail] = col_yellow_hover,
        },
        [SchemeTagEmpty] = {
            [ColFg] = col_black,
            [ColBg] = col_light_red_hover,
            [ColDetail] = col_red_hover,
        }
    }
};

static const char *windowcolors[2][7][3] = {
    [SchemeNoHover] = {
        [SchemeWinFocus] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_accent,
            [ColDetail] = col_light_blue,
        },
        [SchemeWinNormal] = {
            [ColFg] = col_text,
            [ColBg] = col_bg,
            [ColDetail] = col_bg,
        },
        [SchemeWinMinimized] = {
            [ ColFg ] = "#888888",
            [ ColBg ] = col_bg,
            [ ColDetail ] = col_bg,
        },
        [SchemeWinSticky] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_yellow,
            [ ColDetail ] = col_yellow,
        },
        [ SchemeWinStickyFocus ] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_green,
            [ ColDetail ] = col_green
        },
        [SchemeWinOverlay] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_yellow,
            [ ColDetail ] = col_yellow,
        },
        [SchemeWinOverlayFocus] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_green,
            [ ColDetail ] = col_green,
        },
    },
    //TODO: different hover colors
    [SchemeHover] = {
        [SchemeWinFocus] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_accent_hover,
            [ColDetail] = col_light_blue_hover,
        },
        [SchemeWinNormal] = {
            [ColFg] = col_text,
            [ColBg] = col_bg_hover,
            [ColDetail] = col_bg_hover,
        },
        [SchemeWinMinimized] = {
            [ ColFg ] = col_text,
            [ ColBg ] = col_bg,
            [ ColDetail ] = col_bg,
        },
        [SchemeWinSticky] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_yellow_hover,
            [ ColDetail ] = col_yellow_hover,
        },
        [ SchemeWinStickyFocus ] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_green_hover,
            [ ColDetail ] = col_green_hover
        },
        [SchemeWinOverlay] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_yellow_hover,
            [ ColDetail ] = col_yellow_hover,
        },
        [SchemeWinOverlayFocus] = {
            [ ColFg ] = col_black,
            [ ColBg ] = col_light_green_hover,
            [ ColDetail ] = col_green_hover,
        },
    }
};

static const char *closebuttoncolors[2][3][3] = {
    [SchemeNoHover] = {
        [ SchemeCloseNormal ] = {
            [ColFg] = col_text,
            [ColBg] = col_light_red,
            [ColDetail] = col_red,
        }, 
        [ SchemeCloseLocked ] = {
            [ ColFg ] = col_text, 
            [ ColBg ] = col_light_yellow,
            [ ColDetail ] = col_yellow
        }, 
        [ SchemeCloseFullscreen ] = {
            [ColFg] = col_text,
            [ColBg] = col_light_red,
            [ColDetail] = col_red,
        }, 
    }, 
    [ SchemeHover ] = {
        [ SchemeCloseNormal ] = {
            [ColFg] = col_text,
            [ColBg] = col_light_red_hover,
            [ColDetail] = col_red_hover,
        }, 
        [ SchemeCloseLocked ] = {
            [ ColFg ] = col_text, 
            [ ColBg ] = col_light_yellow_hover,
            [ ColDetail ] = col_yellow_hover
        },
        [ SchemeCloseFullscreen ] = {
            [ColFg] = col_text,
            [ColBg] = col_light_red_hover,
            [ColDetail] = col_red_hover,
        }, 
    }
};

static const char *bordercolors[] = {
    [ SchemeBorderNormal ] = col_bg_accent,
    [ SchemeBorderTileFocus ] = col_light_blue,
    [ SchemeBorderFloatFocus ] = col_light_green,
    [ SchemeBorderSnap ] = col_light_yellow
};

static const char *statusbarcolors[] = {
    [ ColFg ] = col_text,
    [ ColBg ] = col_bg,
    [ ColDetail ] = col_bg
};

SchemePref schemehovertypes[] = {
    { "hover", SchemeHover }, 
    { "nohover", SchemeNoHover }
};

SchemePref schemewindowtypes[] = {
    {"normal", SchemeWinNormal},
    {"minimized", SchemeWinMinimized},
    {"sticky", SchemeWinSticky},
    {"focus", SchemeWinFocus},
    {"stickyfocus", SchemeWinStickyFocus},
    {"overlay", SchemeWinOverlay},
    {"overlayfocus", SchemeWinOverlayFocus},
};

SchemePref schemetagtypes[] = {
    {"inactive", SchemeTagInactive},
    {"filled", SchemeTagFilled},
    {"focus", SchemeTagFocus},
    {"nofocus", SchemeTagNoFocus},
    {"empty", SchemeTagEmpty},
};

SchemePref schemeclosetypes[] = {
    {"normal", SchemeCloseNormal},
    {"locked", SchemeCloseLocked},
    {"fullscreen", SchemeCloseFullscreen},
};

SchemePref schemecolortypes[] = {
    {"fg", ColFg},
    {"bg", ColBg},
    {"detail", ColDetail},
};

/* tagging */
#define MAX_TAGLEN 16
static const char *tags_default[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "s"};
static char tags[][MAX_TAGLEN] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "s" };
/* ffox, programming1, term, music, steam, folder, play icon, document, message  */
static const char *tagsalt[] = { "", "{}", "$", "", "", "", "", "", "" };

/* tagging
#define MAX_TAGLEN 16
static const char *tags_default[] = {"1", "2", "3", "4" };
static char tags[][MAX_TAGLEN] = { "1", "2", "3", "4" };
/* ffox, programming1, term, music, steam, folder, play icon, document, message
static const char *tagsalt[] = { "A", "B", "C", "D" }; */
static const char scratchpadname[] = "instantscratchpad";
static const char *upvol[] = { "amixer", "-q", "set", "Master", "10%+", "unmute", NULL };
static const char *downvol[] = { "amixer", "-q", "set", "Master", "10%-", "unmute", NULL };
static const char *mutevol[] = { "amixer", "-q", "set", "Master", "toggle", NULL };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                        instance  title  tags mask  isfloating  monitor */
	{"Pavucontrol",                 NULL,     NULL,  0,         0,          -1},
	{scratchpadname,                NULL,     NULL,  0,         4,          -1},
};

/* layout(s) */
static const float mfact = 0.55;  /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;	 /* number of clients in master area */
static const int resizehints = 0; /* 1 means respect size hints in tiled resizals */
static const int decorhints  = 1;    /* 1 means respect decoration hints */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",        tile },    /* first entry is default */
	{ "[#]",        grid },
	{ "><>",        NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[|]",      tcl },
	{ "[D]",      deck },
	{ "[O]",        overviewlayout },
	{ "[B]",      bstack },
	{ "[=]",      bstackhoriz },
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define MODKEYB Mod2Mask
#define MODKEYA Mod1Mask
#define TAGKEYS(KEY, TAG)                                          \
		{MODKEY,			KEY, view, {.ui = 1 << TAG}},\
		{MODKEY|Mod1Mask,		KEY, tag, {.ui = 1 << TAG}}, \
		{MODKEYA,			KEY, followtag, {.ui = 1 << TAG}},\
		{MODKEY|ShiftMask,		KEY, swaptags, {.ui = 1 << TAG}}, \
		{MODKEY|ControlMask, 		KEY, toggleview, {.ui = 1 << TAG}}, \
		{MODKEY|ControlMask|ShiftMask,	KEY, toggletag, {.ui = 1 << TAG}},


#define SHCMD(cmd)                                           \
	{                                                        \
		.v = (const char *[]) { "/bin/zsh", "-c", cmd, NULL } \
	}

/* commands */
static char instantmenumon[2] = "0"; /* component of instantmenucmd, manipulated in spawn() */
static const char *instantshutdowncmd[] = { "rofi", "-show", "p", "-modi", "p:rofi-power-menu", "-me-select-entry", "", "-me-accept-entry", "MousePrimary",  NULL };
static const char *instantswitchcmd[] = {"/home/hudamuhamad/.local/bin/window", NULL};
static const char  *startmenucmd[] = { "/home/hudamuhamad/.local/bin/dmenux", NULL };
static const char *termscratchcmd[] = {"st", "-c", scratchpadname, NULL};
static const char *quickmenucmd[] = {"dmenu_run", NULL};
static const char *termcmd[] = {"st", NULL};
static const char *thunar[] = {"thunar", NULL};
static const char *onboardcmd[] = {"onboard", NULL};
static const char *instantmenucmd[] = {"instantmenu_run", NULL};
static const char *caretinstantswitchcmd[] = {"rofi", "-show", "run", "-show-icons", "Alt+Tab,Down", "-kb-row-up", "Alt+Ctrl+Tab,Up", "-kb-accept-entry", "!Alt_L,!Alt+Tab,Return", "-me-select-entry", "", "-me-accept-entry", "MousePrimary",  NULL};

#include "push.c"
ResourcePref resources[] = {
    { "barheight",        INTEGER, &barheight },
    { "font",             STRING,  &xresourcesfont },

    // set tag labels
    { "tag1",             STRING,  &tags[0] },
    { "tag2",             STRING,  &tags[1] },
    { "tag3",             STRING,  &tags[2] },
    { "tag4",             STRING,  &tags[3] },
    { "tag5",             STRING,  &tags[4] },
    { "tag6",             STRING,  &tags[5] },
    { "tag7",             STRING,  &tags[6] },
    { "tag8",             STRING,  &tags[7] },
    { "tag9",             STRING,  &tags[8] },
};

// instantwmctrl commands
static Xcommand commands[] = {
	/* signum       function        default argument  arg handler*/
	// 0 means off, 1 means toggle, 2 means on
    	// arg handlers:
    	// 0  no argument
    	// 1  binary toggle
    	// 3  tag number (bitmask)
    	// 4  string
    	// 5  integer
	{ "overlay",                setoverlay,                   {0},         0 },
	{ "warpfocus",              warpfocus,                   {0},         0 },
	{ "tag",                    view,                         { .ui = 2 }, 3 },
	{ "animated",               toggleanimated,               { .ui = 2 }, 1 },
	{ "border",                 setborderwidth,               { .i =  borderpx  }, 5 },
	{ "focusfollowsmouse",      togglefocusfollowsmouse,      { .ui = 2 }, 1 },
	{ "focusfollowsfloatmouse", togglefocusfollowsfloatmouse, { .ui = 2 }, 1 },
	{ "alttab",                 alttabfree,                   { .ui = 2 }, 1 },
	{ "layout",                 commandlayout,                { .ui = 0 }, 1 },
	{ "prefix",                 commandprefix,                { .ui = 1 }, 1 },
	{ "alttag",                 togglealttag,                 { .ui = 0 }, 1 },
	{ "hidetags",               toggleshowtags,               { .ui = 0 }, 1 },
	{ "specialnext",            setspecialnext,               { .ui = 0 }, 3 },
	{ "tagmon",                 tagmon,                       { .i = +1 }, 0 },
	{ "followmon",              followmon,                    { .i = +1 }, 0 },
	{ "focusmon",               focusmon,                     { .i = +1 }, 0 },
	{ "focusnmon",               focusnmon,                   { .i = 0 }, 5 },
	{ "nametag",                nametag,                      { .v = "tag" }, 4 },
	{ "resetnametag",           resetnametag,                 {0}, 0 },
};

static Key dkeys[] = {
	/* modifier  key        function     argument */
	{0,          XK_slash, 	spawn,         SHCMD("xfce4-terminal") },
	{0,          XK_equal,  spawn,       {.v = upvol} },
	{0,          XK_minus,  spawn,       {.v = downvol} },
	{0,          XK_space,  spawn,       {.v = startmenucmd} },
	{0,          XK_a,  	spawn,       SHCMD("brave-browser") },
	{0,          XK_Left,   viewtoleft,  {0}},
	{0,          XK_Right,  viewtoright, {0}},
};

static Key keys[] = {
	/* modifier                             key                 function              argument */
 	{MODKEY,					XK_period,          cyclelayout,          	{.i = +1 } },
   	{MODKEY,					XK_F1,              tagmon,               	{.i = -1 } },
   	{MODKEY,					XK_F2,			followmon,            	{.i = -1}},
	{MODKEYA,					XK_Tab,             spawn,                	{.v = instantswitchcmd}},
	{MODKEY,					XK_Tab,             lastview,             	{0}},
   	{MODKEY,					XK_q,               focusmon,             	{.i = -1 } },
	{MODKEYA,					XK_q,               shutkill,             	{0}},
	{MODKEY,					XK_w,               setlayout,            	{.v = &layouts[3]}},
	{MODKEY,					XK_e,               setlayout,            	{.v = &layouts[0]}},
	{MODKEY,					XK_r,               setlayout,            	{.v = &layouts[7]}},

	{MODKEY,					XK_z,               setoverlay,           	{0} },
	{MODKEYA,					XK_z,               createoverlay,        	{0} },
	{MODKEY,					XK_x,          		zoom,                 	{0}},

	{MODKEYA,					XK_a,               togglefloating,    		{0} },
	{MODKEY,					XK_a,               focusstack,           	{.i = +1}},
	{MODKEYA,					XK_s,               createscratchpad,     	{0}},
	{MODKEY,					XK_s,               togglescratchpad,     	{0}},
	{MODKEY,					XK_d,               spawn,			{.v = startmenucmd}},
	{MODKEY,					XK_f,               tempfullscreen,       	{0} },

	{MODKEY,					XK_v,               fullovertoggle,       	{.ui = ~0}},
	{MODKEY,					XK_b,               togglebar,            	{0}},
	{MODKEY,					XK_p,			spawn,             {.v = quickmenucmd}},
	{MODKEY,					XK_Down,            setmfact,             	{.f = -0.05}},
	{MODKEY,					XK_Up,              setmfact,             	{.f = +0.05}},
	{MODKEY|ControlMask,		XK_Left,            moveleft,             	{0}},
	{MODKEY|ControlMask,		XK_Right,           moveright,            	{0}},
	{MODKEY|MODKEYA,			XK_Left,            tagtoleft,            	{0}},
	{MODKEY|MODKEYA,			XK_Right,           tagtoright,           	{0}},
	{MODKEY,					XK_Left,            animleft,             	{0}},
	{MODKEY,					XK_Right,           animright,            	{0}},
	{MODKEY,					XK_bracketleft,     incnmaster,           	{.i = +1}},
	{MODKEY,					XK_bracketright,    incnmaster,           	{.i = -1}},
	{MODKEYA,					XK_slash, 			spawn,          		{.v = termcmd } },
	{MODKEY,					XK_Print,  			spawn,      			SHCMD("xfce4-screenshooter") },
    {MODKEY,					XK_End,             quit,    				{0}},
	{0,							XF86XK_AudioLowerVolume,  spawn,   			{.v = downvol}},
	{0,							XF86XK_AudioMute,         spawn,   			{.v = mutevol}},
	{0,							XF86XK_AudioRaiseVolume,  spawn,   			{.v = upvol}},
	TAGKEYS(XK_1, 0)
	TAGKEYS(XK_2, 1)
	TAGKEYS(XK_3, 2)
	TAGKEYS(XK_4, 3)
	TAGKEYS(XK_5, 4)
	TAGKEYS(XK_6, 5)
	TAGKEYS(XK_7, 6)
	TAGKEYS(XK_8, 7)
	TAGKEYS(XK_9, 8)
};

/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click          event mask          button   function           argument */
	{ ClkLtSymbol,    0,                  Button1, cyclelayout,       {.i = +1 } },
	{ ClkLtSymbol,    0,                  Button3, spawn,			SHCMD("xfce4-screenshooter") },
    { ClkCloseButton, 0,                  Button3, killclient,        {0} },
	{ ClkCloseButton, 0,                  Button1, togglelocked,      {0} },
	{ ClkWinTitle,     0,                  Button1, dragmouse,         {0} },
    { ClkWinTitle,     0,                  Button3, dragrightmouse,    {0} },
	{ ClkWinTitle,     0,                  Button4, focusstack,        {.i = -1} },
	{ ClkWinTitle,     0,                  Button5, focusstack,        {.i = +1} },
	{ ClkStatusText,  0,                  Button1, spawn,             {.v = instantswitchcmd } },
	{ ClkStatusText,  0,                  Button3, spawn,             {.v = startmenucmd}},
	{ ClkStatusText,  0,                  Button4, spawn,             {.v = upvol } },
	{ ClkStatusText,  0,                  Button5, spawn,             {.v = downvol } },
	{ ClkRootWin,		0,              Button1,        spawn,             {.v = startmenucmd}},
	{ ClkRootWin,		0,              Button3,        spawn,                	{.v = thunar } },
    { ClkClientWin,   MODKEY,             Button1, 		movemouse,            {0}},
	{ ClkClientWin,   MODKEY,             Button3, 		resizemouse,          {0}},
    { ClkTagBar,      0,                  Button1, dragtag,           {0} },
	{ ClkTagBar,      MODKEY,             Button1, tag,               {0} },
	{ ClkTagBar,      MODKEYA,		Button1, 	followtag,         {0} },
	{ ClkTagBar,      0,                  Button4, viewtoleft,        {0} },
	{ ClkTagBar,      0,                  Button5, viewtoright,       {0} },
	{ ClkShutDown,    0,                  Button1, spawn,             {.v = instantshutdowncmd } },
	{ ClkStartMenu,   0,                  Button1, spawn,             {.v = startmenucmd}},
};

