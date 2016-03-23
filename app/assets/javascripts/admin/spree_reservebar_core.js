//= require admin/spree_core
//= require admin/spree_auth
//= require_tree .

$(function(){
  // Toggle Engraving
  $('#product_engravable').change(function() {
    if( $(this).attr('checked') == 'checked') {
      $('#engraving-properties').show();
    }
    else {
      $('#engraving-properties').hide();
    }
  });

  $('#enable-change-retailer').click(function() {
    $('#enable-change-retailer').hide()
    $('#change_retailer').show()
  });

  $('#enable-force-update').click(function() {
    $('#enable-force-update').hide()
    $('#force-update').show()
  });

});
