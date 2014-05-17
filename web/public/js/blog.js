$(function() {

  $("#messages-container").hide();
  $("#message-close").on("click", function(){
    $("#messages-container").fadeTo(100, 0, function(){
      $(this).hide();
      $("#content").fadeTo(100, 1, function(){});
    });
    $("#message").html("");
  });

  if ($("#message") && $("#message").html() && $("#message").html().trim().length){
    $("#content").fadeTo(100, 0.4, function(){
      $("#messages-container").fadeTo(100, 1, function(){});
    });
  }

  $(window).scroll( function(){
  
      $('.hideme').each( function(i){
          
          var bottom_of_object = $(this).position().top + $(this).outerHeight();
          var top_of_window = $(window).scrollTop();

          if( (top_of_window > bottom_of_object) && $("#blog-logo").css("opacity") == 0 ){
              $("#blog-logo").fadeTo("fast", 1, function(){

              });
          }
          
          if( (top_of_window <= bottom_of_object) && $("#blog-logo").css("opacity") == 1 ){
              $("#blog-logo").fadeTo("fast", 0, function(){

              });
          }
          
      }); 
  
  });
});
