(function(ns){
    ns = ns || {};
    ns.transitions = ns.transitions || {};

    ns.transitions.ArticleOpening = function(article_pages, articles){
        var blog_logo_closes_article = function(article_id){
            $('#blog-logo').off("click");
            $('#blog-logo').on("click", function(){
                article_pages.close(article_id, articles.open);
            });
        };

        var switch_to_article = function(article_id){
            articles.close(function(){
                article_pages.open(article_id, function(){
                    articles.finish_closing();
                    blog_logo_closes_article(article_id);
                });
            })
        };

        var _run = function(post){
            if (!article_pages.contains(post.id)){
                var article_page = new APP.widgets.Article(post);
                article_pages.add_page(article_page);
            }

            switch_to_article(post.id);
        };

        return {
            run: _run
        }
    };

    return ns;
}(APP));
