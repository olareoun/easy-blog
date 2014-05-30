var APP = {};

$(function() {
  common_init();
  if ($(".blog-content") && $(".blog-content").length) initialize_blog();
});

var initialize_blog = function() {
  APP.articles = new APP.widgets.Articles();
  APP.article_pages = new APP.widgets.ArticlePages();

  APP.services.get_articles(draw_articles);
  $('#blog-logo').on("click", APP.articles.open);
};

var draw_articles = function(data){
  data.forEach(function(post){
    var article = new APP.widgets.ArticleThumbnail(post);

    var article_opening = new APP.transitions.ArticleOpening(APP.article_pages, APP.articles);
    article.on_click(article_opening.run);

    APP.articles.add_article(article);
  });
};

var common_init = function(){
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

};

