// (function($){
  $(document).ready(function(){
    initialize();
    setInterval(function(){ initialize() }, 10000);

    function initialize(){
      var image = getSvgImage();
      $('#spacer').html(image);
    }

    function getSvgImage(){
      var start_x = 0;
      var start_y = 0;
      var image = "<svg  width=100% height='300'>" ;
      for(var i = 0; i<7; i++ ){
        for(var j = 0; j<50; j++){
          var randomRed = Math.floor(Math.random() * (256));
          var randomGreen = Math.floor(Math.random() * (256));
          var randomBlue = Math.floor(Math.random() * (256));
          image += "<circle cx='" + start_x +"' cy='" + start_y + 
                   "' r='100' style='fill:rgb(" + 
                   randomRed+ ","+ randomGreen + "," + randomBlue + ");'>" +"<animate attributeName='opacity'"+
                   "values='0.1;0.6;0.1' dur='10s'repeatCount='indefinite'/>" +"</circle>";
          start_x += 100;
        }
        start_y += 100;
        start_x = 0;
      }
      image += "</svg>";

      return image;
    }

  });
// }($));