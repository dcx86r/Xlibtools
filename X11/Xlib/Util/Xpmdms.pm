package X11::Xlib::Util::Xpmdms;

use strict;
use warnings;

use Inline C => Config =>
           LIBS => '-lXpm -lX11',
           INC  => '--std=c11';

use Inline C => <<'...';

#include <X11/xpm.h>

int get_width(char* filename) {
	char** data_return;
	if (XpmReadFileToData(filename, &data_return) != XpmSuccess) {
		return -1;
	}
	const char* width = strtok(*(data_return), " ");
	XpmFree(data_return);
	return atoi(width);
}

...

1;
