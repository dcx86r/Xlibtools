package X11::Xlib::Util::Xfndms;

use strict;
use warnings;

use Inline C => Config =>
           LIBS => '-lX11 -lXft -lfontconfig -lfreetype',
           INC  => '--std=c11 -I/usr/include/uuid -I/usr/include/freetype2 -I/usr/include/libpng16';

use Inline C => <<'...';

#include <X11/Xft/Xft.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xrender.h>
#include <fontconfig/fontconfig.h>

#ifndef Newx
#	define Newx(v,n,t) New(0,v,n,t)
#endif

typedef struct {
	char* name;
	size_t name_len;
	Display* dpy;
	XftFont* fn;
} FnInfo;

SV* new(const char * classname, const char * fname) {
	FnInfo* font;
	SV* obj;
	SV* obj_ref;

	Newx(font, 1, FnInfo);
	font->name = savepv(fname);
	font->name_len = strlen(font->name);
	font->dpy = XOpenDisplay(0);
	font->fn = XftFontOpenName(font->dpy, 0, font->name);
	obj = newSViv((IV)font);
	obj_ref = newRV_noinc(obj);
	sv_bless(obj_ref, gv_stashpv(classname, GV_ADD));
	SvREADONLY_on(obj);
	return obj_ref;
}

int monospace(SV* obj) {
	FnInfo* font = (FnInfo*)SvIV(SvRV(obj));
	XGlyphInfo ext;
	XftTextExtentsUtf8(font->dpy, font->fn, " ", 1, &ext);
	int val = ext.xOff;
	XftTextExtentsUtf8(font->dpy, font->fn, "0", 1, &ext);
	return (ext.xOff == val) ? 1 : 0;
}

int get_width(SV* obj, char* txt) {
	FnInfo* font = (FnInfo*)SvIV(SvRV(obj));
	XGlyphInfo ext;
	char* text = txt;
	size_t len = strlen(text);
  	FcChar8 str[len];
  	memcpy(str, text, len);
  	XftTextExtentsUtf8(font->dpy, font->fn, str, (int)len, &ext);
	return ext.xOff;
}

void DESTROY(SV* obj) {
	FnInfo* font = (FnInfo*)SvIV(SvRV(obj));
	XftFontClose(font->dpy, font->fn);
	XCloseDisplay(font->dpy);
	Safefree(font);
}

...

1;
