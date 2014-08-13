$(document).ready(function() {
  $('.engraving_text').keyup(function(){
     newValue = this.value.toUpperCase();
     return this.value = newValue; 
  });
});
