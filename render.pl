#!/usr/bin/env perl;

use strict;
use warnings;
use feature qw( say );

use Path::Tiny;
use Text::Xslate qw( mark_raw );

my %vars;

foreach my $i ( 1 .. 4 ) {
    my $filename = sprintf( '%s/%s.pl', 'sample-code', $i, '.pl' );

    my $file = path( $filename )->slurp;
    my @file = prepend_text( split m{\n}, $file );

    $vars{ 'example' . $i } = prepend_text( split m{\n}, $file );
    my @results = `perl $filename`;
    $vars{ 'output' . $i } = prepend_text( @results );
}

sub prepend_text {
    my @lines = @_;

    foreach ( @lines ) {
        $_ = sprintf( '%s%s', q{ } x 4, $_ );
    }

    # DDP output will already contain newlines
    return mark_raw( join $lines[0] =~ m{\n} ? q{} : "\n", @lines );
}

my $tx = Text::Xslate->new(
    path   => ['sample-code'],
    syntax => 'TTerse'
);

path( 'README.txt' )
    ->spew( $tx->render( 'blog-post.pod', \%vars ) );
