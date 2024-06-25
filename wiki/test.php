<?php
echo "Testaaa";

exec("lynx -source openrdk.wiki.sourceforge.net", $page);

print_r($page);
echo join($page, "");
?>
