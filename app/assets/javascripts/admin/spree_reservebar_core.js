//= require admin/spree_core
//= require admin/spree_auth
//= require_tree .

// Toggle Engraving
$(function(){
  $('#product_engravable').change(function() {
    if( $(this).attr('checked') == 'checked') {
      $('#engraving-properties').show();
    }
    else {
      $('#engraving-properties').hide();
    }
  });
  $('#product_engraving_font_style').fontselect();

  $('#enable-change-retailer').click(function() {
    $('#enable-change-retailer').hide()
    $('#change_retailer').show()
  });
});
