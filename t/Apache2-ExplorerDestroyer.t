#!perl

use strict;
use warnings;
use Apache2::ExplorerDestroyer;
use Apache::Test;
use Apache::TestRequest;
use Test::More;

our $Levels = 3;

our %Vhost_Matches = (
    Default     =>  qr{\Qgoogle_cpa_choice\E},
    Specified   =>  qr{\Qinclude file succeeded\E},
    PhoneHome   =>  qr{\Qphone_home = 1\E},
);

our %File_Matches = (
    'test.html'     =>  qr{\Q<body onload="hasIE_hideAndShow();">\E},
    'test2.html'    =>  qr{\Q<body onload="foo(); hasIE_hideAndShow();">\E},
    'test3.html'    =>  qr{\Q<body onload="foo(); bar(); baz();  hasIE_hideAndShow();">\E},
);

our @Test_Plan;

my $config = Apache::Test::config();

foreach my $level (1 .. $Levels) {
    my $level_re = qr{\Q- LEVEL $level:\E};
    my $pkg = "Apache2::ExplorerDestroyer::Level$level";
    while(my($vhost, $vhost_re) = each(%Vhost_Matches)) {
        my $vhost_mod = "$pkg\::$vhost";
        Apache::TestRequest::module($vhost_mod);
        my $location = Apache::TestRequest::hostport($config);
        while(my($file, $file_re) = each(%File_Matches)) {
            my $uri = "http://$location/$file";
            push(@Test_Plan, [ $uri, "Crawler", 1, $vhost, $level, { level => $level_re, vhost => $vhost_re, body_tag => $file_re } ]);
            push(@Test_Plan, [ $uri, "GoogleBot", 0, $vhost, $level, { level => $level_re, vhost => $vhost_re, body_tag => $file_re } ]);
        }
    }
}

plan tests => (scalar(@Test_Plan) * 3);

while(my $plan = shift @Test_Plan) {
    my($uri, $ua, $want, $vhost, $level, $tests) = @$plan;
    Apache::TestRequest::user_agent(reset => 1, agent => $ua);
    my $data = GET_BODY $uri;
    while(my($k, $v) = each(%$tests)) {
        my $test_name = "$uri\[$ua/$want/$vhost/$level]: $k";
        if($want) {
            like($data, $v, $test_name);
        } else {
            unlike($data, $v, $test_name);
        }
    }
}
