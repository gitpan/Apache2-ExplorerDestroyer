package Apache2::ExplorerDestroyer;

use 5.006;
use strict;
use warnings;
use constant BUFF_LEN => 1024;
use HTML::PullParser;
use Apache2::Filter ();
use Apache2::RequestRec ();
use Apache2::RequestUtil ();
use APR::Brigade ();
use APR::Table ();
use Apache2::Const qw(OK DECLINED);

our $VERSION = "0.02";

return 1;

sub onload {
    my($class, $f) = @_;
    return "return 'Apache2::ExplorerDestroyer'";
}

sub script {
    my($class, $f, $google_script, $phone_home) = @_;
    return <<"EOT";
$google_script
EOT
}

sub default_google_script {
    my $script = <<EOT;
<script type="text/javascript"><!--
  google_ad_client = "pub-7961868379679320";
  google_ad_width = 125;google_ad_height = 125;
  google_ad_format = "125x125_as_rimg";
  google_cpa_choice = "CAAQo-aZzgEaCM3CU97Siy5UKK2293M";

  //-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
EOT
    return \$script;
}

sub flush {
    my($class, $f, $buffer) = @_;
    $f->print($$buffer);
    $$buffer="";
}

sub transform_buffer {
    my($class, $f, $buffer, $google_script, $phone_home) = @_;
    
    if($$buffer =~ m{(<body[^>]*>)}mi) {
        my $target = $1;
        my $target_len = length($target);
        my $position = index($$buffer, $target);

        # a parser for the sake of one tag?
        # computer cycles are cheaper than brain cycles.
        # this might be slower than putting a regexp in here, but it leans
        # on gisle's prior (and potentially future) art in parsing the HTML.

        my $parser = HTML::Parser->new(
            start_h => [
                sub {
                    my($pos, $text) = @_;
                    my $onload_pos;
                    my @pos = @$pos;
                
                    while(@pos >= 4) {
                        my($k_offset, $k_len, $v_offset, $v_len) =
                            splice(@pos, -4);
                    
                        my $attrname = lc(substr($text, $k_offset, $k_len));

                        if($attrname eq 'onload') {
                            $onload_pos = [ $v_offset, $v_len ];
                        }
                    }
                
                    my $onload = $class->onload($f);
                
                    if($onload_pos) {
                        my $onload_text =
                            substr($text, $onload_pos->[0], $onload_pos->[1] - 1);
                    
                        $onload = "; $onload" unless($onload_text =~ m{;\s*\z}m);
                        
                        substr($text, $onload_pos->[0] + $onload_pos->[1] - 1, 0) =
                            $onload;
                    } else {
                        substr($text, -1, 0) = qq{ onload="$onload"};
                    }
                    
                    $target =
                        $text .
                        $class->script($f, $google_script, $phone_home);
                },
                "tokenpos, text"            
            ]
        );
        
        $parser->attr_encoded(1);
        $parser->parse($target);
        
        substr($$buffer, $position, $target_len) = $target;
    } else {
        die "transform_buffer called on a buffer that doesn't have a body tag";
    }
}

sub get_google_script_file {
    my($class, $google_script_file) = @_;
    if($google_script_file) {
        if(open(my $fh, $google_script_file)) {
            my $google_script = join('', <$fh>);
            return \$google_script;
        } else {
            die qq{GoogleScriptFile open("$google_script_file") failed: $!\n};
        }
    } else {
        die "GoogleScriptFile not specified.\n";
    }
}

sub build_context {
    my($class, $f) = @_;
    my $r = $f->r;
        
    my $google_script_file =
        $r->dir_config("GoogleScriptFile") || 0;
        
    my $phone_home = $r->dir_config("ExplorerDestroyerPhoneHome") ? 1 : 0;
        
    my $google_script = eval {
        $class->get_google_script_file($google_script_file);
    } || $class->default_google_script;
        
    my $google_script_error = $@ || 0;

    $r->headers_out->unset('Content-Length');
    my $buffer;
    my $context = [
        \$buffer, $google_script, $google_script_error, $phone_home
    ];
        
    $f->ctx($context);
    warn $google_script_error if $google_script_error;
        
    return $context;
}

sub handler {
    my($class, $f) = @_;
    my $context = $f->ctx || $class->build_context($f);
    
    my($buffer, $google_script, $google_script_error, $phone_home) = @$context;
    
    while ($f->read(my $in, BUFF_LEN)) {
        $$buffer .= $in;
        if($$buffer =~ m{<body[^>]*>}im) {
            $class->transform_buffer($f, $buffer, $google_script, $phone_home);
            $class->flush($f, $buffer);
        } elsif($$buffer !~ m{<[^>]*\z}m) {
            $class->flush($f, $buffer);
        }
    }
    
    $class->flush($f, $buffer) if($f->seen_eos);
    return OK;
}
