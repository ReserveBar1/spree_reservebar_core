//= require store/spree_core
//= require store/spree_auth
//= require store/reservebar_core
//= require store/purl.js
//= require store/product

// Used for customization_cart partial (engraving)
function validateEngravingText(clase) {
  var tmpvalid = false;
  var divs = $("." + clase);
  var countSwitch = 0;
  var totalSwitch = divs.length;
  divs.each(function () {
    engravid_valid = false;
    $(this).find('input').each(function () {
      if ( $(this).val().length !== 0) {
        engravid_valid = true;
      }
    })
    if (engravid_valid) countSwitch++;
  });
  if (countSwitch === totalSwitch) return true
}

// check that at least one line of engraving data has been entered, before commencing to checkout
$(document).ready(function() {

  $('#checkout-link').click(function(e) {
    if (!validateEngravingText('engraving-text')) {
      e.preventDefault();
      alert('Please enter at least the first line of your engraving data and update the cart.');
    }
  });
});
// END -- Used for customization_cart partial (engraving)
