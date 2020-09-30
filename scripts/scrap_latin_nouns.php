<?php

$nounList = array();
$nextPage = "";
$url = "https://en.wiktionary.org/w/index.php?title=Category:Latin_nouns&from=aa";

do {

	echo $url . "\n";

	$file = file_get_contents($url);
	$file = strstr($file, "<h2>Pages in category");

	preg_match('/\) \(<a href="(.*)" title="Category:Latin nouns">next page<\/a>/U', $file, $nextPage);

	$nextPage[1] = preg_replace('/&amp;/', '&', $nextPage[1]);

	preg_match_all('/title="([a-z]+)">[a-z]+<\/a/', $file, $bulkNouns);
	$lastNoun = "";
	foreach ($bulkNouns[1] as $noun) {
		$nounList[$noun] = 0;
		$lastNoun = $noun;
	}

	echo $lastNoun . "\n";

	$url = "https://en.wiktionary.org" . $nextPage[1];

	sleep(5);
} while ($nextPage[1] != "");

file_put_contents("latin_nouns.txt", implode("\n", array_keys($nounList)));