<html>
<head>
<meta name="generator" content=
"HTML Tidy for Linux (vers 1 September 2005), see www.w3.org">
<title>OpenRDK - Open Robot Development Kit</title>

<style type="text/css">
code { display:block; font-family:monospace; font-size:100%; border:1px solid #eee; padding: 10px; margin: 10px; }
span.pre { clear:none; display:inline; font-family:monospace; font-size:100%; font-weight:500; white-space:normal; }
td.leftColumn, td.rightColumn { width:150px; vertical-align:top; }
td.leftColumn { border-right:1px solid blue; }
td.centralColumn { vertical-align:top; padding:20px; }
table.bigTable { width:100%; border-top:1px solid blue; }
td.centralColumn img { margin:20px; }
</style>
</head>
<body>
<img src="openrdk-logo.jpg">
<table class="bigTable">
<tr>
<td class="leftColumn">
<b>Info</b><br/>
<a href="index.php?q=home">Home</a><br/>
<a href="index.php?q=credits">Credits</a><br/>
<a href="index.php?q=installation">Install and compile</a><br/>
<br/>
<b>Tutorials</b><br/>
<a href="index.php?q=tutorial-primer">Beginner</a><br/>
<a href="index.php?q=tutorial-player">Player/Stage</a><br/>
<br/>
<b>Documentation</b><br/>
<a href="docsy/">Doxygen</a><br/>
<a href="index.php?q=publications">Publications</a><br/>
<br/>
<b>SourceForge</b><br/>
<a href="https://sourceforge.net/project/showfiles.php?group_id=213249" target="_BLANK">Download</a><br/>
<a href="http://lists.sourceforge.net/mailman/listinfo/openrdk-help" target="_BLANK">Support ML</a><br/>
</td>
<td class="centralColumn"><?php
$page = '';
if (!isset($_GET['q'])) $page = 'home';
else $page = $_GET['q'];

$f = file_get_contents($page.'.txt');
$f = str_replace('<pre>', '<span class="pre">', $f);
$f = str_replace('</pre>', '</span>', $f);
print $f;

?></td>
<td class="rightColumn"></td>
</tr>
</table>
</body>
</html>
