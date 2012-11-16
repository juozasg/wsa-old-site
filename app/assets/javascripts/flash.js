//= require jquery_ujs

$(document).ready(function(){
    $('form input[type=text]:first').focus();
  init_flash_messages();
});

init_flash_messages = function(){
  $('.flash').css({
    'opacity': 0
    , 'visibility':'visible'
  }).animate({'opacity': '1'}, 550);
  $('.flash').show();

  $('.flash_close').live('click', function(e) {
    try {
      var my_flash = $(this).parents('.flash');
      console.log("hiding...");
      console.log(my_flash);
      my_flash.animate({
         'opacity': 0,
         'visibility': 'hidden'
      }, 330, function() {
        my_flash.hide();
      });
    } catch(ex) {
      my_flash.hide();
    }
    e.preventDefault();
  });
  $('.flash.flash_message').prependTo('#records');
};



