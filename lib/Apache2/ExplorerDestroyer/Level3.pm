package Apache2::ExplorerDestroyer::Level3;

use strict;
use warnings;
use Apache2::ExplorerDestroyer;
use base q(Apache2::ExplorerDestroyer);

return 1;

sub onload { return "hasIE_hideAndShow();"; }

sub script { my($class, $f, $google_script, $phone_home) = @_; return <<"EOT"; }
<!--      EXPLORER DESTROYER      -->
<!--     explorerdestroyer.com    -->

<!--     LEVEL 3:  DEAD-SERIOUS    -->

<!-- 

UNDER 50 SETTING

If you would like to send stats to explorerdestroyer.com about what percentage of your visitors are using IE, set the variable below called 'hasIE_phone_home' to 1.  

Check out the sidebar on explorerdestroyer.com for more info about the 'get under 50' campaign.  If the variable is set to 0, no info will be sent.

-->


<script type="text/javascript">
<!--

var hasIE_phone_home = $phone_home;

// This function does the actual browser detection
function hasIE_hasIE() {
  var ua = navigator.userAgent.toLowerCase();
  return ((ua.indexOf('msie') != -1) && (ua.indexOf('opera') == -1) && 
          (ua.indexOf('webtv') == -1) &&
          (location.href.indexOf('seenIEPage') == -1));
}

function hasIE_showOnlyLayer(whichLayer)
{
  if (document.getElementById)
    {
      var style2 = document.getElementById(whichLayer);
    }
  else if (document.all)
    {
      var style2 = document.all[whichLayer];
    }
  else if (document.layers)
    {
      var style2 = document.layers[whichLayer];
    }
  var body = document.getElementsByTagName('body');
  body[0].innerHTML = style2.innerHTML;
}

function hasIE_showLayer(whichLayer)
{
  if (document.getElementById)
    {
      var style2 = document.getElementById(whichLayer).style;
      style2.display = "block";
    }
  else if (document.all)
    {
      var style2 = document.all[whichLayer].style;
      style2.display = "block";
    }
  else if (document.layers)
    {
      var style2 = document.layers[whichLayer].style;
      style2.display = "block";
    }
}

function hasIE_moveAd(adid) {
  if (document.getElementById)
    {
      var ad = document.getElementById('hasIE_ad');
      var adloc = document.getElementById(adid);
    }
  else if (document.all)
    {
      var ad = document.all['hasIE_ad'];
      var adloc = document.all[adid];
    }
  else if (document.layers)
    {
      var ad = document.layers['hasIE_ad'];
      var adloc = document.layers[adid];
    }
  adloc.innerHTML = ad.innerHTML;
}

// Hides and shows sections of the page based on whether or not it's
// running in IE
function hasIE_hideAndShow() {
  if (hasIE_hasIE()) {
    hasIE_showOnlyLayer("hasIE_level3");
          if (hasIE_phone_home == 1)
            hasIE_phoneHome('getIE_pingimage3');
  } else {
    if (hasIE_phone_home == 1)
      hasIE_phoneHome('getIE_pingimage0');
  }
}

function hasIE_phoneHome(image) {
  if (document.getElementById)
    {
      var img = document.getElementById(image);
    }
  else if (document.all)
    {
      var img = document.all[image];
    }
  else if (document.layers)
    {
      var img = document.layers[image];
    }
  img.setAttribute('src','http://getunder50.com/ping.php?host='+location.host);

}

function hasIE_ContinueWithoutFF() {
    if (location.href.indexOf('?') != -1)
        location.href += '&seenIEPage=1';
    else
        location.href += '?seenIEPage=1';
}

-->
</script>

<span style="position:absolute; width: 0px; height:0px; left:-1000px; top: -1000px"><img id="getIE_pingimage0"/></span>

<!-- LEVEL 3: SPLASH WITH NO CLICK THROUGH --> 

<div id="hasIE_level3" style="display: none;">
<span style="position:absolute; width: 0px; height:0px; left:-1000px; top: -1000px"><img id="getIE_pingimage3"/></span>

<Br /><Br />

<div style="padding: 20px; background-color: #ffffbb; font-family: arial; font-size: 15px; font-weight: normal; color: #111111; line-height: 17px;">


<div style="width: 630px; margin: 0 auto 0 auto;">

<div style="padding-left: 10px; padding-top: 0px; float: right;">


<!-- REPLACE THIS BLOCK OF SCRIPT WITH YOUR OWN FIREFOX REFERRAL BUTTON -->

$$google_script

<!--                                                   -->


</div>

<strong>We see you're using Internet Explorer, which is not compatible with this site.&nbsp;&nbsp;We strongly suggest downloading Firefox.  We think you'll like it better:</strong>  
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>&middot;</strong> Firefox blocks pop-up windows.
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>&middot;</strong> It's more secure against viruses and spyware.
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>&middot;</strong> It keeps Microsoft from controlling the future of the internet.
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>&middot;</strong> It's better for web designers and developers.
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>&middot;</strong> Features like tabbed browsing make reading webpages easier.


<br /><br />
Click the button on the right to download Firefox.&nbsp;&nbsp;It's free.
<br /><br /><br />

</div>

</div>


</div> <!-- CLOSES LEVEL 3 DISPLAY SECTION -->


<!-- ------YOUR NORMAL PAGE CONTENT GOES BELOW THIS LINE------ -->

EOT
