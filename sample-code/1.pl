#!/usr/bin/env perl;

use strict;
use warnings;

use Data::Printer;
use Sort::ByExample qw( sbe );

my @example = (
    'Rudolph', 'Dasher', 'Dancer', 'Prancer', 'Vixen', 'Comet',
    'Cupid',   'Donner', 'Blitzen',
);
my $sorter = sbe( \@example );

my @current_lineup = (
    'Dave',   'Shirley', 'Bubba', 'Rudolph', 'Vixen', 'Dasher',
    'Donner', 'Zeke',    'Audrey',
);

my @sorted = $sorter->( @current_lineup );

print np( @sorted );
