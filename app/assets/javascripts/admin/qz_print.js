$(function(){
  // Find printer after printer selection is made.
  $('#printerList').change(function () {
      var str = "";
      $("#printerList option:selected").each(function () {
          str += $(this).text() + " ";
      });
      findPrinter()
  });
});

/**
* Automatically gets called when applet has loaded.
*/
function qzReady() {
  // Setup our global qz object
  window["qz"] = document.getElementById('qz');
  var title = document.getElementById("title");
  if (qz) {
    try {
      title.innerHTML = title.innerHTML + " " + qz.getVersion();
    } catch(err) { // LiveConnect error, display a detailed meesage
      alert("ERROR:  \nThe applet did not load correctly.  Communication to the " + 
        "applet has failed, likely caused by Java Security Settings.  \n\n" + 
        "CAUSE:  \nJava 7 update 25 and higher block LiveConnect calls " + 
        "once Oracle has marked that version as outdated, which " + 
        "is likely the cause.  \n\nSOLUTION:  \n  1. Update Java to the latest " + 
        "Java version \n          (or)\n  2. Lower the security " + 
        "settings from the Java Control Panel.\n\n\nNOTE: It is likely this is " +
        "only a warning and the printer will still work.");
    }
  }
}

/**
* Returns whether or not the applet is not ready to print.
* Displays an alert if not ready.
*/
function notReady() {
  // If applet is not loaded, display an error
  if (!isLoaded()) {
    return true;
  }
  // If a printer hasn't been selected, display a message.
  else if (!qz.getPrinter()) {
    alert('Please select a printer first');
    return true;
  }
  return false;
}

/**
* Returns is the applet is not loaded properly
*/
function isLoaded() {
  if (!qz) {
    alert('Error:\n\n\tPrint plugin is NOT loaded!');
    return false;
  } else {
    try {
      if (!qz.isActive()) {
        alert('Error:\n\n\tPrint plugin is loaded but NOT active!');
        return false;
      }
    } catch (err) {
      alert('Error:\n\n\tPrint plugin is NOT loaded properly!');
      return false;
    }
  }
  return true;
}

/**
* Automatically gets called when "qz.print()" is finished.
*/
function qzDonePrinting() {
  // Alert error, if any
  if (qz.getException()) {
    alert('Error printing:\n\n\t' + qz.getException().getLocalizedMessage());
    qz.clearException();
    return; 
  }
  
  // Alert success message
  alert('Successfully sent print data to "' + qz.getPrinter() + '" queue.');
}

/***************************************************************************
* Prototype function for finding the closest match to a printer name.
* Usage:
*    qz.findPrinter('zebra');
*    window['qzDoneFinding'] = function() { alert(qz.getPrinter()); };
***************************************************************************/
function findPrinter(name) {
  // Get printer name from input box
  var p = document.getElementById('printerList');
  if (name) {
    p.value = name;
  }
  
  if (isLoaded()) {
    // Searches for locally installed printer with specified name
    qz.findPrinter(p.value);
    
    // Automatically gets called when "qz.findPrinter()" is finished.
    window['qzDoneFinding'] = function() {
      var p = document.getElementById('printerList');
      var printer = qz.getPrinter();
      
      // Alert the printer name to user
      alert(printer !== null ? 'Printer found: "' + printer + 
        '" after searching for "' + p.value + '"' : 'Printer "' + 
        p.value + '" not found.');
      
      // Remove reference to this function
      window['qzDoneFinding'] = null;
    };
  }
}

/***************************************************************************
* Prototype function for listing all printers attached to the system
* Usage:
*    qz.findPrinter('\\{dummy_text\\}');
*    window['qzDoneFinding'] = function() { alert(qz.getPrinters()); };
***************************************************************************/
function findPrinters() {
  if (isLoaded()) {
    // Searches for a locally installed printer with a bogus name
    qz.findPrinter('\\{bogus_printer\\}');
    
    // Automatically gets called when "qz.findPrinter()" is finished.
    window['qzDoneFinding'] = function() {
      // Get the CSV listing of attached printers
      var printers = qz.getPrinters().split(',');
      for (i in printers) {
        $('<option/>').val(printers[i]).html(printers[i]).appendTo('#printerList'); 
      }
      
      // Remove reference to this function
      window['qzDoneFinding'] = null;
    };
  }
}

/***************************************************************************
****************************************************************************
* *                          OLD jZEBRA CODE                              **
****************************************************************************
***************************************************************************/

/* Item can be a gift message or a shipping label */
function printItem() {
  if (isLoaded()) {
    $("#progress").slideDown();
    qz.findPrinter($("#printerList option:selected").text());
    appendItem();
  }
}

function appendItem() {
  if (isLoaded()) {
    if (!qz.isDoneFinding()) {
          window.setTimeout('appendItem()', 100);
      } else {
      if ($("#jzebra_dialog").attr("format") == 'raw') {
          qz.appendFile($("#jzebra_dialog").attr("url"));
      } 
      else if ($("#jzebra_dialog").attr("format") == 'html') {
          qz.appendHTMLFile($("#jzebra_dialog").attr("url"));
      }
      else {
        qz.appendPDF($("#jzebra_dialog").attr("url"));
      }
      //wait for appending to finish before attempting to print: (monitorAppending will print when ready)
      monitorAppending();
    }
  }
}
  
function monitorPrinting() {
  $("#progress").slideUp();
  hidePrintDialog();
}
    
function monitorAppending() {
  if (isLoaded()) {
     if (!qz.isDoneAppending()) {
        window.setTimeout('monitorAppending()', 100);
     } else {
      if ($("#jzebra_dialog").attr("format") == 'raw') {
            qz.print(); // Don't print until all of the data has been appended
      } 
      else if ($("#jzebra_dialog").attr("format") == 'html') {
        qz.printHTML();
      }
      else {
        qz.printPS(); // PDF documents use printPS function
      }
            monitorPrinting();
     }
  } else {
          alert("Applet not loaded!");
      }
}   

/* format is 'raw','pdf' */
function showPrintDialog(shipment_number, label_url, format, printer) {
  $("#jzebra_dialog").param
  $("#jzebra_shipment").html(shipment_number);
  $("#jzebra_dialog").attr("url", label_url);
  $("#jzebra_dialog").attr("format", format);
  $("#jzebra_dialog").attr("printer", printer);
  $("#jzebra_dialog").show();
  if (format == 'raw') {
    $("#jzebra_shipment_row").show();
  } else {
    $("#jzebra_gift_message_row").show();
  }
}

function hidePrintDialog() {
  $("#jzebra_dialog").hide();
}


/***************************************************************************
****************************************************************************
* *                          HELPER FUNCTIONS                             **
****************************************************************************
***************************************************************************/


/***************************************************************************
* Gets the current url's path, such as http://site.com/example/dist/
***************************************************************************/
function getPath() {
  var path = window.location.href;
  return path.substring(0, path.lastIndexOf("/")) + "/";
}

/**
* Fixes some html formatting for printing. Only use on text, not on tags!
* Very important!
*   1.  HTML ignores white spaces, this fixes that
*   2.  The right quotation mark breaks PostScript print formatting
*   3.  The hyphen/dash autoflows and breaks formatting  
*/
function fixHTML(html) {
  return html.replace(/ /g, "&nbsp;").replace(/’/g, "'").replace(/-/g,"&#8209;"); 
}

/**
* Equivelant of VisualBasic CHR() function
*/
function chr(i) {
  return String.fromCharCode(i);
}

/***************************************************************************
* Prototype function for allowing the applet to run multiple instances.
* IE and Firefox may benefit from this setting if using heavy AJAX to
* rewrite the page.  Use with care;
* Usage:
*    qz.allowMultipleInstances(true);
***************************************************************************/ 
function allowMultiple() {
  if (isLoaded()) {
  var multiple = qz.getAllowMultipleInstances();
  qz.allowMultipleInstances(!multiple);
  alert('Allowing of multiple applet instances set to "' + !multiple + '"');
  }
}
