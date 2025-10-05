// (C) Wolfgang Huber 2010-2011

// Script parameters - these are set up by R in the function 'writeReport' when copying the 
//   template for this script from arrayQualityMetrics/inst/scripts into the report.

var highlightInitial = [ false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, true, false, true, false, false, false, false, false, true, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false ];
var arrayMetadata    = [ [ "1", "GSM1859079_001MB0C.CEL.gz", "1", "02/19/09 14:10:03" ], [ "2", "GSM1859080_001RS01.CEL.gz", "2", "05/09/08 11:21:17" ], [ "3", "GSM1859081_002FM01.CEL.gz", "3", "05/09/08 12:28:49" ], [ "4", "GSM1859082_002MC0C.CEL.gz", "4", "02/19/09 13:37:28" ], [ "5", "GSM1859083_003GC0C.CEL.gz", "5", "02/19/09 13:43:56" ], [ "6", "GSM1859084_003ZA01.CEL.gz", "6", "2010-06-22T09:18:30Z" ], [ "7", "GSM1859085_004GQ0C.CEL.gz", "7", "02/19/09 13:50:21" ], [ "8", "GSM1859086_004LN01.CEL.gz", "8", "12/19/08 11:41:00" ], [ "9", "GSM1859087_005MZ0C.CEL.gz", "9", "02/19/09 13:56:48" ], [ "10", "GSM1859088_005PN01.CEL.gz", "10", "12/19/08 11:28:07" ], [ "11", "GSM1859089_006LS01.CEL.gz", "11", "12/19/08 11:47:23" ], [ "12", "GSM1859090_006ZB0C.CEL.gz", "12", "02/20/09 11:47:18" ], [ "13", "GSM1859091_007MC0C.CEL.gz", "13", "02/20/09 11:53:53" ], [ "14", "GSM1859092_007US01.CEL.gz", "14", "12/19/08 11:53:46" ], [ "15", "GSM1859093_008MB0C.CEL.gz", "15", "02/20/09 12:00:20" ], [ "16", "GSM1859094_009GM0C.CEL.gz", "16", "02/20/09 12:06:46" ], [ "17", "GSM1859095_009WB01.CEL.gz", "17", "02/18/09 12:09:49" ], [ "18", "GSM1859096_010SK01.CEL.gz", "18", "12/23/08 11:25:37" ], [ "19", "GSM1859097_011GB0C.CEL.gz", "19", "2010-06-22T09:44:42Z" ], [ "20", "GSM1859098_011MF01.CEL.gz", "20", "12/23/08 11:19:07" ], [ "21", "GSM1859099_012IK0C.CEL.gz", "21", "2010-06-22T09:51:20Z" ], [ "22", "GSM1859100_012MB01.CEL.gz", "22", "12/23/08 11:12:42" ], [ "23", "GSM1859101_013FB0C.CEL.gz", "23", "2010-06-23T09:29:08Z" ], [ "24", "GSM1859102_013SR01.CEL.gz", "24", "12/23/08 11:06:13" ], [ "25", "GSM1859103_014GS01.CEL.gz", "25", "02/18/09 12:16:14" ], [ "26", "GSM1859104_014MF0C.CEL.gz", "26", "2010-06-23T09:35:37Z" ], [ "27", "GSM1859105_015MS01.CEL.gz", "27", "12/23/08 10:59:43" ], [ "28", "GSM1859106_015PS0C.CEL.gz", "28", "2010-06-24T09:01:18Z" ], [ "29", "GSM1859107_016BF0C.CEL.gz", "29", "2010-06-24T09:58:38Z" ], [ "30", "GSM1859108_016MG01.CEL.gz", "30", "02/18/09 12:22:40" ], [ "31", "GSM1859109_017AS0C.CEL.gz", "31", "2010-06-23T09:42:07Z" ], [ "32", "GSM1859110_017PB01.CEL.gz", "32", "02/18/09 12:29:22" ], [ "33", "GSM1859111_018LC0C.CEL.gz", "33", "2010-06-24T09:52:03Z" ], [ "34", "GSM1859112_018RD01.CEL.gz", "34", "02/18/09 12:35:45" ], [ "35", "GSM1859113_019AP0C.CEL.gz", "35", "2010-06-25T08:55:52Z" ], [ "36", "GSM1859114_019MT01.CEL.gz", "36", "02/18/09 12:42:08" ], [ "37", "GSM1859115_020FG01.CEL.gz", "37", "02/18/09 13:35:15" ], [ "38", "GSM1859116_020MB0C.CEL.gz", "38", "2010-06-25T09:02:17Z" ], [ "39", "GSM1859117_021LK01.CEL.gz", "39", "2010-06-22T09:11:52Z" ], [ "40", "GSM1859118_022ZP01.CEL.gz", "40", "2010-06-22T09:58:09Z" ], [ "41", "GSM1859119_023PP01.CEL.gz", "41", "2010-06-22T09:25:06Z" ], [ "42", "GSM1859120_024BS01.CEL.gz", "42", "2010-06-22T09:31:42Z" ], [ "43", "GSM1859121_025FS01.CEL.gz", "43", "2010-06-22T09:38:14Z" ], [ "44", "GSM1859122_026LB01.CEL.gz", "44", "2010-06-23T08:56:08Z" ], [ "45", "GSM1859123_027MM01.CEL.gz", "45", "2010-06-23T09:02:45Z" ], [ "46", "GSM1859124_028DL01.CEL.gz", "46", "2010-06-23T09:09:20Z" ], [ "47", "GSM1859125_029EP01.CEL.gz", "47", "2010-06-23T09:15:55Z" ], [ "48", "GSM1859126_030AZ01.CEL.gz", "48", "2010-06-23T09:22:32Z" ], [ "49", "GSM1859127_031MC01.CEL.gz", "49", "2010-06-25T08:21:21Z" ], [ "50", "GSM1859128_032AS01.CEL.gz", "50", "2010-06-24T09:39:09Z" ], [ "51", "GSM1859129_033CG01.CEL.gz", "51", "2010-06-24T09:16:30Z" ], [ "52", "GSM1859130_034LM01.CEL.gz", "52", "2010-06-24T09:09:45Z" ], [ "53", "GSM1859131_035NH01.CEL.gz", "53", "2010-06-24T09:32:32Z" ], [ "54", "GSM1859132_036LL01.CEL.gz", "54", "2010-06-24T09:45:39Z" ], [ "55", "GSM1859133_037MC01.CEL.gz", "55", "2010-06-25T09:15:22Z" ], [ "56", "GSM1859134_038SS01.CEL.gz", "56", "2010-06-25T08:36:23Z" ], [ "57", "GSM1859135_039GF01.CEL.gz", "57", "2010-06-25T08:43:00Z" ], [ "58", "GSM1859136_040GG01.CEL.gz", "58", "2010-06-25T09:08:54Z" ], [ "59", "GSM1859137_041BB01.CEL.gz", "59", "2010-06-25T08:49:27Z" ] ];
var svgObjectNames   = [ "pca", "dens", "dig" ];

var cssText = ["stroke-width:1; stroke-opacity:0.4",
               "stroke-width:3; stroke-opacity:1" ];

// Global variables - these are set up below by 'reportinit'
var tables;             // array of all the associated ('tooltips') tables on the page
var checkboxes;         // the checkboxes
var ssrules;


function reportinit() 
{
 
    var a, i, status;

    /*--------find checkboxes and set them to start values------*/
    checkboxes = document.getElementsByName("ReportObjectCheckBoxes");
    if(checkboxes.length != highlightInitial.length)
	throw new Error("checkboxes.length=" + checkboxes.length + "  !=  "
                        + " highlightInitial.length="+ highlightInitial.length);
    
    /*--------find associated tables and cache their locations------*/
    tables = new Array(svgObjectNames.length);
    for(i=0; i<tables.length; i++) 
    {
        tables[i] = safeGetElementById("Tab:"+svgObjectNames[i]);
    }

    /*------- style sheet rules ---------*/
    var ss = document.styleSheets[0];
    ssrules = ss.cssRules ? ss.cssRules : ss.rules; 

    /*------- checkboxes[a] is (expected to be) of class HTMLInputElement ---*/
    for(a=0; a<checkboxes.length; a++)
    {
	checkboxes[a].checked = highlightInitial[a];
        status = checkboxes[a].checked; 
        setReportObj(a+1, status, false);
    }

}


function safeGetElementById(id)
{
    res = document.getElementById(id);
    if(res == null)
        throw new Error("Id '"+ id + "' not found.");
    return(res)
}

/*------------------------------------------------------------
   Highlighting of Report Objects 
 ---------------------------------------------------------------*/
function setReportObj(reportObjId, status, doTable)
{
    var i, j, plotObjIds, selector;

    if(doTable) {
	for(i=0; i<svgObjectNames.length; i++) {
	    showTipTable(i, reportObjId);
	} 
    }

    /* This works in Chrome 10, ssrules will be null; we use getElementsByClassName and loop over them */
    if(ssrules == null) {
	elements = document.getElementsByClassName("aqm" + reportObjId); 
	for(i=0; i<elements.length; i++) {
	    elements[i].style.cssText = cssText[0+status];
	}
    } else {
    /* This works in Firefox 4 */
    for(i=0; i<ssrules.length; i++) {
        if (ssrules[i].selectorText == (".aqm" + reportObjId)) {
		ssrules[i].style.cssText = cssText[0+status];
		break;
	    }
	}
    }

}

/*------------------------------------------------------------
   Display of the Metadata Table
  ------------------------------------------------------------*/
function showTipTable(tableIndex, reportObjId)
{
    var rows = tables[tableIndex].rows;
    var a = reportObjId - 1;

    if(rows.length != arrayMetadata[a].length)
	throw new Error("rows.length=" + rows.length+"  !=  arrayMetadata[array].length=" + arrayMetadata[a].length);

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = arrayMetadata[a][i];
}

function hideTipTable(tableIndex)
{
    var rows = tables[tableIndex].rows;

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = "";
}


/*------------------------------------------------------------
  From module 'name' (e.g. 'density'), find numeric index in the 
  'svgObjectNames' array.
  ------------------------------------------------------------*/
function getIndexFromName(name) 
{
    var i;
    for(i=0; i<svgObjectNames.length; i++)
        if(svgObjectNames[i] == name)
	    return i;

    throw new Error("Did not find '" + name + "'.");
}


/*------------------------------------------------------------
  SVG plot object callbacks
  ------------------------------------------------------------*/
function plotObjRespond(what, reportObjId, name)
{

    var a, i, status;

    switch(what) {
    case "show":
	i = getIndexFromName(name);
	showTipTable(i, reportObjId);
	break;
    case "hide":
	i = getIndexFromName(name);
	hideTipTable(i);
	break;
    case "click":
        a = reportObjId - 1;
	status = !checkboxes[a].checked;
	checkboxes[a].checked = status;
	setReportObj(reportObjId, status, true);
	break;
    default:
	throw new Error("Invalid 'what': "+what)
    }
}

/*------------------------------------------------------------
  checkboxes 'onchange' event
------------------------------------------------------------*/
function checkboxEvent(reportObjId)
{
    var a = reportObjId - 1;
    var status = checkboxes[a].checked;
    setReportObj(reportObjId, status, true);
}


/*------------------------------------------------------------
  toggle visibility
------------------------------------------------------------*/
function toggle(id){
  var head = safeGetElementById(id + "-h");
  var body = safeGetElementById(id + "-b");
  var hdtxt = head.innerHTML;
  var dsp;
  switch(body.style.display){
    case 'none':
      dsp = 'block';
      hdtxt = '-' + hdtxt.substr(1);
      break;
    case 'block':
      dsp = 'none';
      hdtxt = '+' + hdtxt.substr(1);
      break;
  }  
  body.style.display = dsp;
  head.innerHTML = hdtxt;
}
