package Data::Utils;

use warnings;
use strict;
require Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( true false );


=head1 NAME

Data::Utils - Utility functions for data conversion

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Data::Utils;

    $x = true; $y = false;
    my $value = Data::Utils->size_to_bytes("1.23GB");

    ...

=head1 CONSTANTS

The following constants are declared for general use

    true:  syntactic sugar, allowing one if use a somewhat more readable
           code style.  Evaluates to 1.
           
    false: syntactic sugar, allowing one if use a somewhat more readable
           code style.  Evaluates to 0.

=cut


use constant true   => (1==1);
use constant false  => (1==0);    


=head1 FUNCTIONS

=head2 function1

=cut


sub units {
    my $self	= shift;
    my $units;
    $units ->{SI} = {
	  order => [qw(B kB MB GB TB PB EB ZB YB)],
	  B   => 1,
	  kB  => 1000,
	  MB  => 1000*1000,
	  GB  => 1000*1000*1000,
	  TB  => 1000*1000*1000*1000,
	  PB  => 1000*1000*1000*1000*1000,
	  EB  => 1000*1000*1000*1000*1000*1000,
	  ZB  => 1000*1000*1000*1000*1000*1000*1000,
	  YB  => 1000*1000*1000*1000*1000*1000*1000*1000
	 };
    
    $units ->{IEC} = {
	  order => [qw(B KiB MiB GiB TiB PiB EiB ZiB YiB)],
	  B   => 1,
	  KiB => 1024,
	  MiB => 1024*1024,
	  GiB => 1024*1024*1024,
	  TiB => 1024*1024*1024*1024,
	  PiB => 1024*1024*1024*1024*1024,
	  EiB => 1024*1024*1024*1024*1024*1024,
	  ZiB => 1024*1024*1024*1024*1024*1024*1024,
	  YiB => 1024*1024*1024*1024*1024*1024*1024*1024,
	 };
    return $units;
}

sub size_to_bytes {
    my ($self,$string,$attr)  = @_;
    my $rv;
    
    # %attrs => {debug => true} will turn on debugging
    my $debug;
    $debug	= $attr->{'debug'} if (defined($attr->{'debug'}));
    
    # input string in the form (\d+\.{0,1}\d{0,})\s{0,}([kKMGTPEZY]{0,1}i{0,1}B)
    # return the size in bytes of this string
    my $units	= $self->units();
    $rv	= undef;
    if ($string =~ /(\d+\.{0,1}\d{0,})\s{0,}([kKMGTPEZY]{0,1}i{0,1}B)/)
       {
	my $scale	= $2;
	my $value	= $1;
	my $type	= 'Data';
	$type	= 'IEC' if ($scale =~ /.iB/i);
	printf STDERR "D[%i] Data::Utils::size_to_bytes value,scale,type=%s, %s, %s\n",$$,$value,$scale,$type if ($debug);
	
	$rv	= $value * $units->{$type}->{$scale};
       }
      elsif ($string =~ /(\d+\.{0,1}\d{0,})/)
       {
	$rv	= $string;
       }
    return $rv;
}

sub bytes_to_size {
    my ($self,$value,$attrs)  = @_;
    my ($rv,$type,$debug);
    # input value in bytes
    # if $scale is not defined, then set scale to MB
    # if $digits is not defined, then set digits to 3
    $debug	= $attrs->{'debug'} if (defined($attrs->{'debug'}));
    
    $attrs->{digits}	= 3 	if (!$attrs->{digits});
    $attrs->{scale}	= "MB"	if (!$attrs->{scale});
    $type	= "SI";
    $type	= "IEC" if ($attrs->{scale} =~ /.iB/);
    
    my $units	= $self->units();
    my $tmp_rv 	= ($value ? $value/$units->{$type}->{$attrs->{scale}} : 0);
    my $fmt	= "%.".(sprintf '%i',$attrs->{digits})."f %s";
    printf STDERR "D[%i] Data::Utils::bytes_to_size tmp_rv,units,fmt=\'%s\', %s, %s\n",$$,$tmp_rv,$attrs->{scale},$fmt if ($debug);
    $rv		= sprintf $fmt,$tmp_rv,$attrs->{scale};
    return $rv;
}


=head2 rescale

=cut

sub rescale {
    my ($self,$string,$attrs)  = @_;
    my ($rv,$actual);
    # input string in the form (\d+\.{0,1}\d{0,})\s{0,}([kKMGTPEZY]{0,1}i{0,1}B)
    # return the size in bytes of this string
    my $units	= $self->units();
    
    # %attrs => {debug => true} will turn on debugging
    my $debug;
    $debug	= $attrs->{'debug'} if (defined($attrs->{'debug'}));
    $actual	= $self->size_to_bytes($string,$attrs);
    $rv		= $self->bytes_to_size($actual,$attrs);
    printf STDERR "D[%i] Data::Utils::rescale string,actual,units = %s, %s, %s\n",$$,$string,$actual,$attrs->{scale} if ($debug);
    return $rv;
}

=head2 autoscale

=cut

sub autoscale {
    my ($self,$string,$attrs)  = @_;
    my ($rv,$actual,$scale,$type,$digits,$tmp_rv,$q);
    # input string in the form (\d+\.{0,1}\d{0,})\s{0,}([kKMGTPEZY]{0,1}i{0,1}B)
    # return the size in bytes of this string
    my $units	= $self->units();
    
    # %attrs => {debug => true} will turn on debugging
    my $debug;
    $debug	= $attrs->{'debug'} if (defined($attrs->{'debug'}));
    $actual	= $self->size_to_bytes($string,$attrs);
    $attrs->{digits}	= 3 	if (!$attrs->{digits});
    $type	= "SI";
    $type	= "IEC" if (
			    ($attrs->{scale} && ($attrs->{scale} =~ /.iB/)) ||
			    ($attrs->{scale} && ($attrs->{units}=~/IEC/i))
			   );
    printf STDERR "D[%i] Data::Utils::autoscale string,actual,type = %s, %s, %s\n",$$,$string,$actual,$type if ($debug);
   
    # now progressively divide actual by $units->{$type}->{$scale} until we have no more than 3 digits
    # before the decimal
    my @order	= @{$units->{$type}->{order}};
    printf STDERR "D[%i] Data::Utils::autoscale order = %s\n",$$,join(",",@order) if ($debug);
    foreach $scale (@order)
      {
        printf STDERR "D[%i]  Data::Utils::autoscale loop actual,scale, units = %s, %s, %s\n",$$,$actual,$units->{$type}->{$scale},$scale if ($debug);
	$tmp_rv	= ($actual ? $actual / $units->{$type}->{$scale} : 0);
        printf STDERR "D[%i]  Data::Utils::autoscale loop tmp_rv = %s\n",$$,$tmp_rv if ($debug);
	$q	= int($tmp_rv);
        printf STDERR "D[%i]  Data::Utils::autoscale loop q = %s\n",$$,$q if ($debug);
	if (
	    (length($q) >= 1) &&
	    (length($q) <= 3) &&
	    int($q) >= 1
	   )
	   {
	    my $fmt	= '%.'.(sprintf '%i',$attrs->{digits})."f %s";
	    printf STDERR "D[%i]  Data::Utils::autoscale final format fmt=\'%s\', tmp_rv=%s, scale=%s\n",$$,$fmt,$tmp_rv,$scale if ($debug);
            $q  	= sprintf $fmt,$tmp_rv,$scale;
	    $tmp_rv	= $q;
	    last;
	   }
      }
    $rv		= $tmp_rv;
    return $rv;
}

=head1 AUTHOR

Joe Landman, C<< <landman at scalability.org> >>

=head1 BUGS





=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Utils


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Utils>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Utils>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-Utils>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-Utils>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2015 Joe Landman, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Data::Utils
