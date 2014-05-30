(function(ns){
  ns = ns || {};
  ns.widgets = ns.widgets || {};

  ns.widgets.ArticlePages = function(){
    var container = $('body');
    var _pages = {};

    var _contains = function(article_id){
        return _pages[article_id];
    };

    var _add_page = function(page){
        _pages[page.article_id] = page;
        container.append(page.render());
    };

    var _open = function(article_id, callback){
        var article = _pages[article_id];
        article.element.css({"height": "auto"});
        article.element.show();
        var bg_color = article.element.attr("data-color");
        var bg_complimentary = article.element.attr("data-complimentary");
        APP.helpers.customize_logos(bg_color, bg_complimentary);

        article.element.animate(
            { opacity: 1, width: "100%" },
            {
                duration: "fast",
                complete: function() {
                    article.element.removeClass("girado");
                    article.element.addClass("enfrentado");
                    callback();
                }
            });
    };

    var _close = function(article_id, callback){
        var article = _pages[article_id];
        article.element.css({ "height": "100%" });
        article.element.animate(
            { height: 0, width: 0 },
            {
              duration: "fast",
              complete: function(){
                callback();
                article.element.removeClass("enfrentado");
                article.element.addClass("girado");
              }
            }
        );
    };

    return {
        add_page: _add_page,
        contains: _contains,
        open: _open,
        close: _close
    }
  };

  ns.widgets.Articles = function(){
    var container = $('#content');
    var blog_content = $(".blog-content");
    var articles = $("<section>");
    articles.addClass('articles');
    blog_content.append(articles);

    var _add_article = function(article){
      articles.prepend(article.render());
    };

    var _close = function(callback){
        container.animate(
            { opacity: 0 },
            {
                complete: function() {
                    window.scrollTo(0, 0);
                    callback();
                }
            }
        );
    };

    var _finish_closing = function(){
        container.hide();
        container.addClass("girado");
        container.removeClass("enfrentado");
    };

    var _open = function(){
        container.show();
        container.animate(
            { opacity: 1 },
            {
                duration: "fast",
                complete: function() {
                    container.removeClass("girado");
                    container.addClass("enfrentado");
                }
            }
        );
    };

    return {
        add_article: _add_article,
        close: _close,
        finish_closing: _finish_closing,
        open: _open
    }
  };

  ns.widgets.ArticleThumbnail = function(post){
    var article = $('<article>');
    article.addClass('post-thumbnail');

    var post_image = $('<div>');
    post_image.addClass('post-image');
    var my_image = $('<img>');
    my_image.addClass('custom-img');
    my_image.attr("src", post.image == undefined? "/img/no-image.png": post.image);
    post_image.append(my_image);

    var post_date = $('<div>');
    post_date.addClass('post-update');
    post_date.append(post.updated);
    post_image.append(post_date);
    article.append(post_image);

    var post_content = $('<div>');
    post_content.addClass('post-content')
    var post_title = $('<h1>');
    post_title.html(post.title);
    post_content.append(post_title);

    var post_summary = $('<div>');
    post_summary.addClass('summary');
    post_summary.html(post.content.substring(0, 250));
    post_content.append(post_summary);

    var post_url = $('<a>');
    var eye = $('<img>');
    eye.attr("src", '/img/021.png');
    eye.addClass('read');
    post_url.append(eye);
    post_content.append(post_url);

    article.append(post_content);

    return {
        render: function(){
            return article;
        },
        on_click: function(transition){
            post_url.on("click", function(){
                transition(post);
            });
        }
    }
  };

  ns.widgets.Article = function(post){
    var article_container = $("<div class='article-container girado'>");
    article_container.attr("id", post.id);

    var post_section = $('<section>');
    post_section.addClass("post");

    var post_header = $('<section>');
    post_header.addClass('post-header');

    var one_image = new Image();
    one_image.src = post.image;

    var colors = APP.helpers.calculate_colors(one_image);

    article_container.attr("data-color", colors.rgb);
    article_container.attr("data-complimentary", colors.compl);
    $(one_image).css({"border": "2px solid " + colors.compl});
    post_header.append($(one_image));

    var post_title = $('<h1>');
    post_title.html(post.title);
    post_title.css(
      {
        "background-color": colors.compl,
        "color": colors.rgb
      }
    );
    post_header.append(post_title);

    var date = $('<span class="post-date">');
    date.html(post.updated);
    date.css(
      {
        "color": colors.compl,
        "border-bottom": "1px solid " + colors.compl
      }
    );
    post_header.append(date);

    article_container.css({"background-color": colors.rgb});
    post_section.append(post_header);

    var post_content = $('<section>')
    post_content.addClass('post-content');
    post_content.append(post.content);
    post_content.css({"color": colors.compl});

    post_section.append(post_content);

    article_container.append(post_section);

    return {
        render: function(){
            return article_container;
        },
        article_id: function(){
            return post.id;
        }(),
        element: function(){
            return article_container;
        }()
    }
  };


  return ns;
}(APP));
