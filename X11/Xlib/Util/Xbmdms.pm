package Local::Xbmdms;

use strict;
use warnings;

use Inline C => Config =>
           LIBS => '-lX11',
           INC  => '--std=c11';

use Inline C => <<'...';

#include <X11/Xlib.h>

#ifndef Newx
#	define Newx(v,n,t) New(0,v,n,t)
#endif

typedef struct {
	unsigned int w, h;
	unsigned char* data_return;
	int xh, yh;
} BmInfo;

SV* new(const char* classname) {
	BmInfo* bm;
	SV* obj;
	SV* obj_ref;

	Newx(bm, 1, BmInfo);

	obj = newSViv((IV)bm);
	obj_ref = newRV_noinc(obj);
	sv_bless(obj_ref, gv_stashpv(classname, GV_ADD));
	SvREADONLY_on(obj);
	return obj_ref;
}

int get_width(SV* obj, char *file) {
	BmInfo* bm = (BmInfo*)SvIV(SvRV(obj));
	XReadBitmapFileData(
		file, &bm->w, &bm->h, &bm->data_return, &bm->xh, &bm->yh
	);
	XFree(bm->data_return);
	return bm->w;
}

void DESTROY(SV* obj) {
	BmInfo* bm = (BmInfo*)SvIV(SvRV(obj));
	Safefree(bm);
}

...

1;
