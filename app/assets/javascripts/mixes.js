$(document).ready(function() {
  $('#mix-fav-btn').click(function() {
    var btn = $(this);
    var href = $(this).attr('href');
    console.log('click');
    console.log(href);
    $.post(href, function(d) {
      if(d.state == 1) {  // Selected
        btn.addClass('btn-primary');
      } else {
        btn.removeClass('btn-primary');
      }
    }).error(function(e) {
      if(e.status == 401) {
        window.location = '/users/sign_up'
      } else {
        alert('An unexpected error has occured. Please try again...');
      }
    });
  });
});
