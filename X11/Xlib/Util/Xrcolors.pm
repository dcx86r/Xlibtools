package X11::Xlib::Util::Xrcolors;

use strict;
use warnings;
use v5.10;
use Carp;

sub get {
	my $self = shift;
	croak "Xres->get() requires argument!" unless @_;
	my $color = shift;
	croak "Color label not found" unless $self->{colors}->{$color};
	return $self->{colors}->{$color};
}

sub set {
	my $self = shift;
	croak "Insufficient arguments" unless scalar(@_) == 2;
	my ($key, $color) = @_;
	croak "Color label unknown"
		unless $self->{colors}->{$key};
	croak "Invalid color value" 
		unless $color =~ m/\#[[:xdigit:]]{3,6}/;
	$self->{colors}->{$key} = $color;
}

sub update {
	my $self = shift;
	return 0 unless grep { -e "$_/xrdb" } split(/:/, $ENV{PATH});
	open(my $xr_data, "-|", "xrdb", "-query") || return $!;
	my @data;
	while (<$xr_data>) {
# skip comments and empty lines
		unless ($_ =~ m/^(!|$)/) {
# skip everything but universal color options
			next if $_ !~ m/^\*\.((cursor)?[cC]olor[0-9]?|(fore|back)ground)/; 
# format the line
			$_ =~ s/^\*\.|(?!:)\s+|\s+$//g;
			push @data, $_;
		}
	}
	$self->{colors} = { map { split(/:/, $_) } @data };
	return 1;												
}

sub new {
	my $class = shift;
	my $self = bless { }, $class;
	my $retval = $self->update();
	carp "Can't find xrdb\n" if $retval < 1;
	carp "Problem running xrdb: $retval\n" if $retval > 1;
	return $self;
}

1;
