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
    my ( undef, undef, $ref_a, $ref_b ) = @_;
    return $ref_b->{seniority} <=> $ref_a->{seniority};
};

my $sorter = sbe(
    \@example,
    {   fallback => $fallback,
        xform    => sub { $_[0]->{name} },
    }
);

my @current_lineup = (
    { name => 'Dave',    seniority => 1 },
    { name => 'Shirley', seniority => 2 },
    { name => 'Bubba',   seniority => 0 },
    { name => 'Rudolph', seniority => 100 },
    { name => 'Vixen',   seniority => 100 },
    { name => 'Dasher',  seniority => 100 },
    { name => 'Donner',  seniority => 150 },
    { name => 'Zeke',    seniority => 44 },
    { name => 'Audrey',  seniority => 44 },
);

my @sorted = $sorter->( @current_lineup );

print np( @sorted );
