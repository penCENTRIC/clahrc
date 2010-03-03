jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", [ "text/javascript", "text/html" ]);
  }
});

var hideFlash = function() {
  $('#flash').fadeOut(1500);
};

$(document).ready(function() {
  document.domain = document.domain.replace(new RegExp(/^(community|my)\./i),"");
  
  $(document).ajaxSend(function(event, request, settings) {
    if (typeof window.AUTH_TOKEN == "undefined") {
      // do nothing
    } else if (settings.type == 'GET' || settings.type == 'get') {
      // do nothing
    } else {
      settings.data = settings.data || "";
      settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
    }
  });
  
  $("#membership_user_id").tokenInput("/members/autocomplete.json", {});
  
  setTimeout(hideFlash, 3500);
  
  $("ul.tabs").tabs(".panes > .pane").history();
  
  $("form :input[title]").tooltip({
    position: "center right",
    offset: [-2, 10],
    effect: "fade",
    opacity: 0.85,
    tip: '#tooltip'
  });

  $(".scrollable").scrollable();
    
  $(function() { 

      // if the function argument is given to overlay, 
      // it is assumed to be the onBeforeLoad event listener 
      $("a[rel]").overlay({ 

          effect: 'apple',
          
          onBeforeLoad: function() { 

              // grab wrapper element inside content 
              var wrap = this.getContent().find(".wrap");

              // load the page specified in the trigger 
              wrap.load(this.getTrigger().attr("href")); 
          } 

      }); 
  });
  
  //$('#q').autocomplete('/members/autocomplete');
});
