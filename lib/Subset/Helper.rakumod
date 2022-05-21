sub subset-is (&check, Str $message = '') is export {
    sub ($v){
        $v.defined
            ?? ( &check($v) or fail $message ~ " Got $v" and False )
            !! True
    };
}

=begin pod

=head1 NAME

Subset::Helper - create awesome subsets

=head1 SYNOPSIS

=begin code :lang<raku>

use Subset::Helper;

subset Positive of Int
    where subset-is * > 0, 'Value must be above zero';

my Positive $x = 42; # success
my Positive $x = -2; # Fails with 'Value must be above zero';

=end code

=head1 DESCRIPTION

This module solves two inconveniences with Raku's subsets:

=item Display of useful error messages when type check fails
=item Avoid evaluating subset's condition for `Any` values, which is what happens with optional parameters.

=head1 EXPORTED SUBROUTINES

=head2 subset-is

B<NOTE>: This functionality broke sometime since 2017 as the returned
C<Failure> for non-matching is somehow ignored, and the message
specified will never be displayed.  Sadly, this was not picked up
by the tests, as these only checked for throwing B<an> exception,
not whether the exception was correctly worded.

Since the 2022.04 release of Rakudo, one can use the C<will complain>
trait instead:

=begin code :lang<raku>

use experimental :will-complain;  # this may become unnecessary

subset Positive of Int:D
  will complain { "need a positive integer, got: $_" }
  where * > 0;

my Positive $a = -2;
# Type check failed in assignment to $a; Need a positive integer, got: -2

my str @cameras = <MAST CHEMCAM FHAZ RHAZ>;
subset RoverCam of Str:D
  will complain { "valid cameras are: @cameras[]" }
  where * ∈ @cameras;

=end code

The original documentation:

=begin code :lang<raku>

subset Positive of Int where subset-is * > 0;

subset RoverCam of Str where subset-is
  { $_ ∈ set <MAST CHEMCAM FHAZ RHAZ> },
  'Valid cameras are MAST, CHEMCAM, FHAZ, and RHAZ';

=end code

Takes one mandatory positional argument, which is the
code to execute to check the validity of value, and an
optional descriptive error message to show when the value
doesn't match the subset.

Note: undefined values are accepted by the subset.
This exists to make it possible to cleanly define subsets
for optional parameters, for which the type check is still
called, even when they aren't provided in the sub/method calls.

=head1 CONFUSING ERRORS

You can't declare our scoped subsets within roles. If you're
using this module, however, that error will instead point
to the end of the declaration, saying C<expecting any of: postfix>.
Simply prefix your subset with C<my>.

=head1 BUGS AND LIMITATIONS

Rakudo may evaluate whether a value matches the subset TWICE:
once to check the match and once to get sensible error information.

Thus, currently the error message you provide is printed twice.

Patches to fix this are welcome.

=head1 AUTHOR

Zoffix Znet

=head1 COPYRIGHT AND LICENSE

Copyright 2016 - 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
