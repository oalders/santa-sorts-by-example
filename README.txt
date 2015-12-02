Title: Santa Sorts By Example
Topic: Sort::ByExample
Author: Olaf Alders <olaf@wundersolutions.com>

=head1 SANTA SORTS BY EXAMPLE

For years Santa has resisted the urge to purchase a self-driving sleigh, but the figures published by recent studies have finally convinced him that an autonomous sled might be safer than one being driven by a man who has been up for 24 hours straight.  Plus, this also allows him to update this Facebook status without having to worry about colliding with other air traffic.

Most of the (literal) bells and whistles on the sleigh come pre-configured.  The only thing Santa really has to worry about is the order in which his reindeer will line up before the sleigh takes off.  (Keep in mind, this sleigh may be self driving, but it's not electric).

For years Santa has called out to his reindeer in a very specific order.  Perhaps you're familiar with it?  Let's just confirm the setup.  Rudolph (a 20th century addition to the team) leads and lights the way.  After that it's: Dasher, Dancer, Prancer, Vixen, Comet, Cupid, Donner and Blitzen.  There's some argument over the spelling of the last two names.  If in doubt, refer to L<Wikipedia|https://en.wikipedia.org/wiki/Santa_Claus%27s_reindeer>.

If any of these reindeer were to take sick, the stand-in reindeer would have to move to the back of the line.  After all, if you've been doing this for over a century, seniority certain enters into the picture.  In order to ensure that the reindeer are guided in the correct order by the self-driving sleigh, Santa reaches into his bag of tricks and scripts up a little something in Perl.  It looks a little like this:

    #!perl
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

This yields the following output:

    #!perl
    [
        [0] "Rudolph",
        [1] "Dasher",
        [2] "Vixen",
        [3] "Donner",
        [4] "Dave",
        [5] "Shirley",
        [6] "Bubba",
        [7] "Zeke",
        [8] "Audrey",
    ]

Looking at the output we can see that:

=over

=item Santa's reindeer appear first in the list, sorted according to seniority

=item Our stand-in reindeer follow in the list, exactly in the order in which they were added to the original list

=back

So far, so good.  Now let's introduce some secondary sorting.  Right now the stand-ins are appearing in the order in which they were originally provided.  Let's sort them alphabetically.

    #!perl
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

This yields:

    #!perl
    [
        [0] "Rudolph",
        [1] "Dasher",
        [2] "Vixen",
        [3] "Donner",
        [4] "Audrey",
        [5] "Bubba",
        [6] "Dave",
        [7] "Shirley",
        [8] "Zeke",
    ]

All we've done here is add a very simple fallback subroutine, which dictates a sort order for any scalars which do not appear in the example list.

Notice that the order of the first four reindeer has not changed, but our stand-ins are now sorted, as we hoped they would be.

Alphabetical order is kind of arbitrary.  What if we wanted to perform the secondary sort according to something more meaningful, like seniority?

    #!perl
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

This yields:

    #!perl
    [
        [0] {
            name      => "Rudolph",
            seniority => 100,
        },
        [1] {
            name      => "Dasher",
            seniority => 100,
        },
        [2] {
            name      => "Vixen",
            seniority => 100,
        },
        [3] {
            name      => "Donner",
            seniority => 150,
        },
        [4] {
            name      => "Zeke",
            seniority => 44,
        },
        [5] {
            name      => "Audrey",
            seniority => 44,
        },
        [6] {
            name      => "Shirley",
            seniority => 2,
        },
        [7] {
            name      => "Dave",
            seniority => 1,
        },
        [8] {
            name      => "Bubba",
            seniority => 0,
        },
    ]

What we've done here is moved from an array of scalars to an array of hash references, which allows us to use more reindeer metadata.  In addition to having a fallback subroutine, we now also have a C<xform> subroutine.  All that C<xform> does is tell us how to extract the keys which might appear in the C<@example> array.

In addition to this, we've now made our C<fallback> enforce seniority, from highest to lowest.

Now, what should we do if there's a tie in seniority, as in the case of Zeke and Audrey?  Let's fall back to alphabetical order in that case.

That leaves us with:

    #!perl
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
        my ( $name_a, $name_b, $ref_a, $ref_b ) = @_;
        return $ref_b->{seniority} <=> $ref_a->{seniority} || $name_a cmp $name_b;
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

Which yields:

    #!perl
    [
        [0] {
            name      => "Rudolph",
            seniority => 100,
        },
        [1] {
            name      => "Dasher",
            seniority => 100,
        },
        [2] {
            name      => "Vixen",
            seniority => 100,
        },
        [3] {
            name      => "Donner",
            seniority => 150,
        },
        [4] {
            name      => "Audrey",
            seniority => 44,
        },
        [5] {
            name      => "Zeke",
            seniority => 44,
        },
        [6] {
            name      => "Shirley",
            seniority => 2,
        },
        [7] {
            name      => "Dave",
            seniority => 1,
        },
        [8] {
            name      => "Bubba",
            seniority => 0,
        },
    ]

Now in the case of Zeke and Audrey, the tiebreaker kicks in and we've got a tertiary sort order.

That's it.  Now Santa can relax.  His reindeer will be queued up in the correct order and his self-driving sleigh will rest assured that it has the correct order in which to call out their names.

Now, as Santa sits back and enjoys the ride, he thinks of other ways in which he can impose arbitrarily complex sort orders.  Perhaps the naughty and nice list is the next logical place?

=head1 See Also

=over

=item *

L<Sort::ByExample>

=back
