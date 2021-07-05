# Xlibtools

This is a small collection of Perl modules for getting information about glyphs 
and icons via the Xlib API.

## Dependencies

* Perl 5
* Inline::C
* C Compiler
* Relevant C libs (see below)

### Xrcolors

**Xrcolors.pm** gets color codes through `xrdb`

Example:

`PERL5LIB=/home/user/dir/to/modules perl -MX11::Xlib::Util::Xrcolors -e 'my $x = 
X11::Xlib::Util::Xrcolors->new; print $x->get('color3')'`

### Xfndms

**Xfndms.pm** gets pixel width of string provided with an XFT font

Requires `Xlib`, `Xft` and `fontconfig` development files

Example:

`PERL5LIB=/home/user/dir/to/modules perl -MX11::Xlib::Util::Xfndms -e 'my $x = 
X11::Xlib::Util::Xfndms->new("Inconsolata:size=16"); print $x->get_width("hi there")'`

*Note* - font string must be in XFT format

### Xbmdms

**Xbmdms.pm** gets width of icons in XBM format

Requires `Xlib` development files

Example:

`PERL5LIB=/home/user/dir/to/modules perl -MX11::Xlib::Util::Xbmdms -e 'my $x = 
X11::Xlib::Util::Xbmdms->new; $x->get_width("/tmp/file.xbm")'`

### Xpmdms

**Xpmdms.pm** gets width of icons in XPM format

Requires `xpm` development files

Example:

`PERL5LIB=/home/user/dir/to/modules perl -MX11::Xlib::Util::Xpmdms -e 'my $x = 
X11::Xlib::Util::Xpmdms::get_width("/tmp/file.xpm")'`

## Notes

*Xfndms.pm* also includes a method `monospace`, which simply returns 1 if the
provided font is monospaced or 0 if not. This can help where the characters in
a string change but the amount of characters stays static - for a monospaced font,
the pixel length will only need to be calculated once in this situation.

## Acknowledgements

This effort was inspired by the [xftwidth](https://github.com/vixus0/xftwidth)
program.
