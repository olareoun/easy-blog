(function(ns){
  ns = ns || {};
  ns.services = ns.services || {};

  ns.services.get_articles = function(callback){
    $.ajax( 
      {
        url: "/olareoun/todo-fluye/json", 
        type: "GET", 
        success: callback,
        error: function(){
          alert("mierder");
        }
      }
    );
  };
  
  return ns;
}(APP));


