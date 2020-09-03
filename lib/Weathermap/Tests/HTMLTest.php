<?php
/**
 * Created by PhpStorm.
 * User: howie
 * Date: 24/09/17
 * Time: 18:38
 */

namespace Weathermap\Tests;

use Weathermap\Core\Map;

class HTMLTest extends \PHPUnit\Framework\TestCase
{

    public function testNotes()
    {
        $testSuiteRoot = realpath(__DIR__ . "/../../../") . "/test-suite";

        $map = new Map();
        $map->readConfig($testSuiteRoot . "/tests/link-notes-1.conf");
        $map->drawMap('null');

        $htmlfile = $testSuiteRoot . "/tmp-link-1.html";

        $fd = fopen($htmlfile, 'w');
        fwrite($fd, $map->makeHTML());
        fclose($fd);

        # check HTML output is correct

        $dom = new \DomDocument;

        $dom->loadHTMLFile($htmlfile);
        $xpath = new \DomXPath($dom);

//        $l1 = $map->getLink('l1');
//        print_r($l1->imagemapAreas);

        $res = $xpath->query('//area');
        $this->assertCount(8, $res, '8 areas. 3 links with 2 areas each (2 arrows) and 2 bwlabels for l2)');

        $res = $xpath->query('//area[@id="LINK:L109:0"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 2", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L109:2"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 2", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L108:0"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 1", $res[0]->nodeValue);


        $res = $xpath->query('//area[@id="LINK:L110:0"]/@onmouseover');
        $this->assertCount(1, $res);
        $this->assertStringContainsString("Note 3 with <b>HTML</b>", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L110:1"]/@onmouseover');
        $this->assertCount(1, $res);
        $this->assertStringContainsString("Note 3 with <b>HTML</b>", $res[0]->nodeValue);



        $map = new Map();
        $map->readConfig($testSuiteRoot . "/tests/link-notes-2.conf");
        $map->drawMap('null');

        $htmlfile = $testSuiteRoot . "/tmp-link-2.html";

        $fd = fopen($htmlfile, 'w');
        fwrite($fd, $map->makeHTML());
        fclose($fd);

        $dom = new \DomDocument;

        $dom->loadHTMLFile($htmlfile);
        $xpath = new \DomXPath($dom);

        $res = $xpath->query('//area');
        $this->assertCount(6, $res);

        $res = $xpath->query('//area[@id="LINK:L108:1"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 1 out", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L108:0"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 1 in", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L110:0"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("Note 3 In with <b>HTML</b>", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L110:1"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("overlib(''", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L109:1"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("'Note 2'", $res[0]->nodeValue);

        $res = $xpath->query('//area[@id="LINK:L109:0"]/@onmouseover');
        $this->assertCount(1, $res, "There should be exactly one AREA");
        $this->assertStringContainsString("'Note 2 In'", $res[0]->nodeValue);
    }
}
