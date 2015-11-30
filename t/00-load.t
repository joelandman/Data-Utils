#!perl -T

use Test::More qw(no_plan);

BEGIN {
	use_ok( 'SI::Utils' );
}

diag( "Testing SI::Utils $SI::Utils::VERSION, Perl $], $^X" );

my $x	= (1==1);
eval { diag("testing true=".true); };
eval {if ($x == true) { pass("true defined") } else { fail("true not defined") } };


my $y	= (1==0);
eval { diag("testing false=".false); };
eval {if ($y == false) { pass("false defined") } else { fail("false not defined") } };
 
my $x1 = SI::Utils->size_to_bytes("1.23GiB",{debug => true});
eval {diag("x1=".$x1)};
if ($x1 == 1320702443.52)
   { 
    pass("x1 = ".$x1);
   }
  else
   { 
    fail("x1 != ".$x1);
   }

my $x2 = SI::Utils->size_to_bytes("1.23 GB",{debug => true});
eval {diag("x2=".$x2)};
if ($x2 == 1230000000)
   {
    pass("x2 = ".$x2);
   }
  else
   { 
    fail("x2 != ".$x2);
   }

$x2 = SI::Utils->size_to_bytes("1.23 kB",{debug => true});
eval {diag("x2=".$x2)};
if ($x2 == 1230)
   {
    pass("x2 = ".$x2);
   }
  else
   {
    fail("x2 != ".$x2);
   }

   
my $x3 = SI::Utils->bytes_to_size(1024,{debug => true});
eval {diag("x3=".$x3)};
if ($x3 =~ "0.001 MB")
   {
    pass("x3 = ".$x3);
   }
  else
   { 
    fail("x3 != ".$x3);
   }
   
my $x4 = SI::Utils->bytes_to_size(1024*1024,{debug => true,digits=>2});
eval {diag("x4=".$x4)};
if ($x4 =~ "1.05 MB")
   {
    pass("x4 = ".$x4);
   }
  else
   { 
    fail("x4 != ".$x4);
   }
   
my $x5 = SI::Utils->bytes_to_size(1024*1024,{debug => true,digits=>1,scale=>"MiB"});
eval {diag("x5=".$x5)};
if ($x5 =~ "1.0 MiB")
   {
    pass("x5 = ".$x5);
   }
  else
   { 
    fail("x5 != ".$x5);
   }

$x1 = SI::Utils->rescale(1000*1024,{debug => true,digits=>1,scale=>"KiB"});
eval {diag("x1=".$x1)};
if ($x1 =~ "1000.0 KiB")
   {
    pass("x1 = ".$x1);
   }
  else
   { 
    fail("x1 != ".$x1);
   }

$x1 = SI::Utils->autoscale(1024*1024*1024*1024,{debug => true,units=>'SI'});
eval {diag("x1=".$x1)};
if ($x1 =~ "1.100 TB")
   {
    pass("x1 = ".$x1);
   }
  else
   { 
    fail("x1 != ".$x1);
   }


