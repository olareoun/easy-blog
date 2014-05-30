(function(ns){
  ns = ns || {};
  ns.helpers = ns.helpers || {};
  
  ns.helpers.customize_logos = function(bg_color, bg_complimentary){
    $("#blog-logo").css(
      {
        "background-color": bg_complimentary
      }
    );
    $("#n2r-logo").css(
      {
        "background-color": bg_complimentary
      }
    );
    $("#blog-logo a").css(
      {
        "color": bg_color
      }
    );
  };

  ns.helpers.calculate_colors = function(image){
    // var rgb = new ColorThief().getColor(image) || [255, 255, 255];
    // var complimentary = $c.complement(rgb).a || [0, 0, 0];
    var rgb = [255, 255, 255];
    var complimentary = [0, 0, 0];
    return {rgb: rgb_format(rgb), compl: rgb_format(complimentary)};
  };

  var rgb_format = function(args){
    return 'rgb(' + args + ')';
  };

  return ns;
}(APP));


