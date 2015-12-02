#!/usr/bin/env perl;

use strict;
use warnings;

use Data::Printer;
use Sort::ByExample qw( sbe );

my @example = (
    'Rudolph', 'Dasher', 'Dancer', 'Prancer', 'Vixen', 'Comet',
    'Cupid',   'Donner', 'Blitzen',
);

my $fallback = sub {
    my ( $name_a, $name_b ) = @_;
    return $name_a cmp $name_b;
};

my $sorter = sbe( \@example, { fallback => $fallback } );

my @current_lineup = (
    'Dave',   'Shirley', 'Bubba', 'Rudolph', 'Vixen', 'Dasher',
    'Donner', 'Zeke',    'Audrey',
);

my @sorted = $sorter->( @current_lineup );

print np( @sorted );
