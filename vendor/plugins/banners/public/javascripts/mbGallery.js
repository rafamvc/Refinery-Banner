/*******************************************************************************
 jquery.mb.components
 Copyright (c) 2001-2009. Matteo Bicocchi (Pupunzi); Open lab srl, Firenze - Italy
 email: info@pupunzi.com
 site: http://pupunzi.com
 Licences: MIT, GPL
 ******************************************************************************/

/*
 * Name:jquery.mb.containerPlus
 * Version: 1.5.5
 */


(function($){

  jQuery.preloadBgnds = function(){
    for(var i = 0; i<arguments.length; i++){
      jQuery("<img>").attr("src", arguments[i]);
    }
  };

  jQuery.fn.mbGallery = function(NewOptions){
    return this.each(function() {
      $(this).hide();
      var galleryId = !this.id ? Math.floor(Math.random() * 100): this.id;
      var origGallery = this;
      if (origGallery.initialized) return;
      origGallery.initialized=true;
      $(origGallery).find("img").each( function(){if($(this).attr("src")) $(this).attr("srcx",$(this).attr("src"));});
      $(origGallery).find("img").removeAttr("src");
      var gallery = $(this).clone();
      gallery.attr("id","gall_"+galleryId);
      galleryId=gallery.attr("id");

      var closeThumbStrip,actualImg,actualThumb,thumbUnsel,thumbOver,thumbs,full,imgDesc;
      var opt = $.extend({}, $.fn.mbGallery.defaults, NewOptions);
      $.preloadBgnds(
              opt.iconFolder+"/thumb.gif",
              opt.iconFolder+"/play.gif",
              opt.iconFolder+"/loaded.gif",
              opt.iconFolder+"/separator.gif",
              opt.iconFolder+"/next.gif",
              opt.iconFolder+"/prev.gif",
              opt.iconFolder+"/close.gif"
              );

      opt.thumbsBorder = opt.thumbsBorder + "px solid";
      var thumbSel = {
        thumbSel:{border: opt.thumbsBorder, borderColor: opt.thumbSelectColor},
        thumbUnsel:{border: opt.thumbsBorder, borderColor: opt.thumbStripColor},
        thumbOver:{border: opt.thumbsBorder, borderColor: opt.thumbOverColor}
      };
      $.extend(opt, thumbSel);
      if(opt.slideTimer < 2000)
        opt.slideTimer = 2000;

      thumbUnsel = opt.thumbUnsel;
      thumbOver = opt.thumbOver;

      // GETTING THE ELEMENTS FOR THE GALLERY FROM THE PAGE
      thumbs = gallery.find(opt.thumbnailSelector);
      full = gallery.find(opt.imageSelector);

      imgDesc = gallery.find(opt.descSelector);
      imgDesc.find("img").each(function(){$(this).attr("src",$(this).attr("srcx"));});
      gallery.empty();
      thumbs.each(function(){$(this).attr("src",$(this).attr("srcx"));});
      full.each(function(){$(this).attr("src",$(this).attr("srcx"));});

      if(opt.startFrom == "random")
        opt.startFrom = Math.floor(Math.random() * full.length);

      function preloadImg(i) {
        $(thumbloading).find("img").attr("src", ""+opt.iconFolder+"/loader.gif");
        var IMG_URL = $(full [i]).attr("src");
        var IMGOBJ = new Image();
        IMGOBJ.onload = function()
        {
          $(thumbloading).find("img").attr("src", ""+opt.iconFolder+"/loaded.gif");
          changePhoto(i);
        };
        IMGOBJ.onerror = function()
        {
          alert("can't load " + IMG_URL);
        };
        IMGOBJ.src = IMG_URL;
      }

      var thumbPos = "";
      function setThumbPos(w) {
        var pos=0;
        switch(opt.thumbStripPos){
          case "left":
            pos= 0;
            break;
          case "center":
            pos=((w / 2) -(opt.thumbStripWidth / 2));
            break;
          case "right":
            pos=(w - opt.thumbStripWidth);
            break;
          default:
            pos= 0;
            break;
        }
        return pos;
      };

      thumbPos = setThumbPos(opt.galleryWidth);

      if(opt.containment=="")
        $("body").append("<div  id='mbg_"+galleryId+"'><div class='mbMask' id='mbMask_"+galleryId+"'></div><table id='tbl_"+galleryId+"'  cellpadding='0' cellspacing='0' height='"+opt.galleryHeight+"'><tr><td id ='gallery_"+galleryId+"' class='mbGallery'></td></tr></table></div>");
      else{
        $("#"+opt.containment).find(".gallery").remove();
        origGallery.initialized=false;        
        $("#"+opt.containment).append("<div class='gallery' id='mbg_"+galleryId+"'><div class='mbMask' id='mbMask_"+galleryId+"'></div><table id='tbl_"+galleryId+"'  cellpadding='0' cellspacing='0' height='"+opt.galleryHeight+"'><tr><td id ='gallery_"+galleryId+"' class='mbGallery'></td></tr></table></div>");
      }

      var galleryContainer= $("#tbl_"+galleryId).find('#gallery_'+galleryId);
      $(galleryContainer).css(
      {
        border: opt.galleryFrameBorder + "px solid " + opt.galleryFrameColor,
        background: opt.galleryColor
      });
      $(galleryContainer).append(gallery);

      // CREATE THE GALLERY STRUCTURE FOR FULLSIZE IMAGES
      $(gallery).append("<div class='FullImg'></div>");
      var fullImageArea =  $(gallery).find(".FullImg");

      var headerH = opt.labelHeight > 0 ? opt.labelHeight: opt.galleryFrameBorder;

      // thumbnail container
      $(galleryContainer).prepend("<div class='thumbBox'></div>");
      var thumbBox = $(galleryContainer).find(" .thumbBox");

      //thumbnail navigator
      $(thumbBox).prepend("<div class='header'>" +
                          "<table cellpadding='0' cellspacing='0'><tr>" +
                          "<td class='thumbWinBtn pointer' > </td>" +
                          "<td class='spacer' > </td>" +
                          "<td class='slideShow pointer' > </td>" +
                          "<td class='spacer' > </td>" +
                          "<td class='prev pointer' > </td>" +
                          "<td class='next pointer' > </td>" +
                          "<td class='spacer' > </td>" +
                          "<td class='loader'> </td>" +
                          "<td class='indexLabel' nowrap> </td>" +
                          "<td class='spacer' > </td>" +
                          "<td class='close' nowrap> </td>" +
                          "</tr></table>" +
                          "</div>");
      var header = $(thumbBox).find(".header");

      var thumbWinBtn = $(header).find(".thumbWinBtn");
      $(thumbWinBtn).append("<img src='"+opt.iconFolder+"/thumb.gif' class='thumbIco'>");

      var slideShow = $(header).find(".slideShow");
      $(slideShow).append("<img src='"+opt.iconFolder+"/play.gif' class='slideIco'>");

      var thumbloading = $(header).find(".loader");
      $(thumbloading).append("<img src='"+opt.iconFolder+"/loaded.gif'>");

      var spacer = $(header).find(".spacer");
      $(spacer).append("<img src='"+opt.iconFolder+"/separator.gif'>");

      var next = $(header).find(".next");
      $(next).append("<img src='"+opt.iconFolder+"/next.gif'>");

      var prev = $(header).find(".prev");
      $(prev).append("<img src='"+opt.iconFolder+"/prev.gif'>");

      var close = $(header).find(".close");
      $(close).append("<img src='"+opt.iconFolder+"/close.gif' alt='close'>");

      var indexLabel = $(thumbBox).find(" .indexLabel").html((opt.startFrom + 1) + ".<b>" + full.length + "</b>");

      //Thumbnails
      $(thumbBox).append("<div class='ThumbImg'></div>");
      var thumbImages = $(thumbBox).find(" .ThumbImg");
      $(thumbImages).prepend($(thumbs));


      $(thumbBox).append("<div class='descriptionBox'></div>");
      var descriptionBox= $(galleryContainer).find(".descriptionBox");

      if(opt.containment=="")
        $("#mbg_"+galleryId).css({
          position:"fixed",
          bottom:0,
          left:0,
          width:"100%",
          height:"100%",
          display:"none"
        });
      else
        $("#mbg_"+galleryId).css({
          position:"relative",
          width:"100%",
          height:"100%",
          display:"none"
        });

      $("#mbMask_"+galleryId).css({
        opacity: opt.maskOpacity,
        background: opt.maskBgnd,
        display:"none"
      });


      $("#tbl_"+galleryId).css({
        margin:"auto",
        top:opt.galleryTop,
        position:"relative"
      });


      $(descriptionBox).css(
      {
        position:"absolute",
        padding:10,
        zIndex:0,
        width:opt.thumbStripWidth-20
      });


      gallery.css(
      {
        width: opt.galleryWidth,
        height: opt.galleryHeight,
        overflow: "hidden"
      });

      $(thumbs).css(
      {
        width: opt.thumbHeight,
        height: $.browser.msie?opt.thumbHeight:"",
        padding:"0px",
        border:"1px solid "+opt.labelColor,
        cursor:"pointer"
      });

      $(thumbBox).css(
      {
        textAlign:"left",
        zindex:1000,
        marginTop:"-" + headerH + "px",
        position:"absolute",
        width:opt.thumbStripWidth + "px",
        marginLeft:thumbPos + "px",
        zIndex:10000
      });

      $(thumbImages).css(
      {
        opacity:opt.headerOpacity,
        backgroundColor:opt.thumbStripColor,
        border:"5px solid "+ opt.labelColor
      });

      $(header).css(
      {
        opacity:opt.headerOpacity,
        textAlign:"left",
        color:opt.labelTextColor,
        padding:"0px",
        border:"0px",
        height:headerH
      });

      $(header).find("td").css(
      {
        background:opt.labelColorDisactive,
        padding:"2px",
        paddingRight:"10px",
        height:headerH,
        color:opt.labelTextColor,
        fontFamily:"Verdana, Arial",
        fontSize:opt.labelTextSize
      });

      $(".pointer").css({cursor:"pointer"});

      jQuery.fn.extend({
        getW:function() {
          var ow = $(this).width();
          if(opt.galleryMaxWidth > 0 && ow > opt.galleryMaxWidth) {
            $(this).attr("width", opt.galleryMaxWidth);
            ow = opt.galleryMaxWidth;
          }
          return ow;
        },
        getH:function() {
          var oh = $(this).height();
          if(opt.galleryMaxHeight > 0 && oh > opt.galleryMaxHeight) {
            $(this).attr("height", opt.galleryMaxHeight);
            oh = $(this).attr("height");
          }
          return oh;
        },
        getDim:function(){
          $(this).removeAttr("width");
          $(this).removeAttr("height");
          var oh = $(this).height();
          var noh = $(this).height();
          var ow = $(this).width();
          var now=$(this).width();
          var wh=opt.containment==""?$(window).height():$("#"+opt.containment).innerHeight();
          var ww=opt.containment==""?$(window).width():$("#"+opt.containment).innerWidth();
          if (opt.galleryMaxHeight>0 && oh>opt.galleryMaxHeight){noh=opt.galleryMaxHeight;}
          if (opt.galleryMaxWidth>0 && ow>opt.galleryMaxWidth){now=opt.galleryMaxWidth;}

          if (noh+opt.galleryTop>=wh){
            noh= wh-opt.galleryTop-30;
            $(this).attr("height", noh);
            now=(noh*ow)/oh;
          }
          if (now+30>=ww){
            now= ww-30;
            $(this).attr("width", now);
            noh=(now*oh)/ow;
          }
          return [noh,now];
        }
      });
      function changePhoto(i) {
        $(descriptionBox).fadeTo(opt.fadeTime, 0);
        $(fullImageArea).fadeTo(opt.fadeTime, 0, function() {
          //replacing the image
          $(fullImageArea).html(full [i]);
          $(descriptionBox).html(imgDesc[i]);
          //showing the new image
          setTimeout(function() {
            $(fullImageArea).fadeTo(opt.fadeTime, 1);
            $(descriptionBox).fadeTo(opt.fadeTime, .8);
          }, opt.fadeTime);
          // if autosize option resize the image frame
          if(opt.autoSize) {
            //if a maxWith is set resize the image width
            var w = $(full [i]).getDim()[1];
            var h = $(full [i]).getDim()[0];
            //resize frame
            gallery.animate(
            {
              height: h,
              width: w
            }, opt.fadeTime);
            //if the thumbstrip has no width set the width according ti the frame width
            if(opt.thumbStripWidth == opt.galleryWidth) {
              $(thumbBox).animate(
              {
                width: full[i].offsetWidth
              },opt.fadeTime);
            } else {
              // if the thumbstrip has a width reposition it according to the image width
              var l = setThumbPos($(full[i]).width());
              $(thumbBox).animate(
              {
                marginLeft: l
              }, opt.fadeTime);
            }
          }
        });
        //redefine the indexLabeles
        $(actualThumb).css(thumbUnsel);
        actualImg = full[i];
        actualThumb = thumbs[i];
        $(actualThumb).css(opt.thumbSel);
        $(indexLabel).html((i +1)+ ".<b>" + full.length + "</b>");
      }
      thumbs.each(function(i) {
        $(this).click(function() {
          x = i;
          stopShow();
          preloadImg(i);
          x++;
        });
      });
      gallery.show();

      // EVENTS
      var hideTumb, thumbOpen, headerMO;
      $(thumbWinBtn).click(function() {
        if( !thumbOpen) {
          $(thumbImages).slideDown(500);
          thumbOpen = true;
        } else {
          $(thumbImages).slideUp(500);
          thumbOpen = false;
        }
        stopShow();
      });
      $(fullImageArea).click(function() {
        stopShow();
      });
      $(fullImageArea).bind("dblclick",function() {
        startShow();
      });
      $(thumbBox).mouseover(function() {
        clearTimeout(hideTumb);
        clearTimeout(headerMO);
        $(header).find("td").css({opacity:opt.headerOpacity, background: opt.labelColor});
        clearTimeout(closeThumbStrip);
      });

      $(thumbBox).mouseout(function() {
        headerMO=setTimeout(function(){
          $(header).find("td").css({opacity:opt.headerOpacity, background: opt.labelColor});
        },100);
        hideTumb = setTimeout(function() {
          $(thumbImages).slideUp(500);
          thumbOpen = false;
        }, 1000);
      });
      $(thumbs).mouseover(function() {
        if(this != actualThumb) {
          $(this).css(thumbOver);
        }
      });
      $(thumbs).mouseout(function() {
        if(this != actualThumb) {
          $(this).css(thumbUnsel);
        }
      });
      $(slideShow).click(function() {
        startSlide = ! startSlide;
        if(startSlide) {
          startShow();
        } else
          stopShow();
      });
      var goOn;
      $(next).click( function() {
        stopShow();
        clearTimeout(goOn);
        x += 1;
        goOn = setTimeout(function() {
          if(x >= full.length) x = 0;
          preloadImg(x);
        }, 200);
      });
      $(prev).click( function() {
        stopShow();
        clearTimeout(goOn);
        x -= 1;
        goOn = setTimeout(function() {
          if(x < 0) x = full.length - 1;
          preloadImg(x);
        }, 200);
      });
      $(close).click( function() {
        stopShow();
        origGallery.initialized=false;
        if (opt.containment==""){
          $("#mbMask_"+galleryId).fadeOut("slow",function(){
            $("#mbg_"+galleryId).slideUp("slow", function(){$("#mbg_"+galleryId).remove();});
          });
        }else{
          $("#mbg_"+galleryId).fadeOut("slow",function(){
            $("#mbg_"+galleryId).remove();});
        }
      });

      $("#mbMask_"+galleryId).click( function() {
        stopShow();
        origGallery.initialized=false;
          $(this).fadeOut("slow",function(){
            $("#mbg_"+galleryId).slideUp("slow", function(){$("#mbg_"+galleryId).remove();});
          });
      });

      actualImg = full [opt.startFrom];
      $(thumbs).css(thumbUnsel);
      actualThumb = thumbs [opt.startFrom];
      $(actualThumb).css(thumbSel);
      closeThumbStrip = setTimeout(function() {
        $(thumbImages).hide(500);
      }, 2000);
      var slideShowTimer,
              x = opt.startFrom,
              startSlide = opt.autoSlide;

      function startShow() {
        $(slideShow).find("img").attr("src", opt.iconFolder+"/stop.gif");
        if(x == full.length)
          x = 0;
        preloadImg(x);
        slideShowTimer = setTimeout(startShow, opt.slideTimer);
        x ++;
      };
      function stopShow() {
        clearTimeout(slideShowTimer);
        $(slideShow).find("img").attr("src", opt.iconFolder+"/play.gif");
        startSlide = false;
      }

      if(startSlide) {
        setTimeout(startShow, opt.startTimer);
      } else {
        setTimeout(function() {
          preloadImg(opt.startFrom);
        }, opt.startTimer);
      }
      if (opt.containment==""){
        $("#mbg_"+galleryId).mb_bringToFront().slideDown("slow",function(){
          $("#mbMask_"+galleryId).fadeIn("slow");
        });
      }else{
        $("#mbg_"+galleryId).mb_bringToFront().fadeIn("slow",function(){
//          $("#mbMask_"+galleryId).fadeIn("slow");
        });
      }
    });
  };

  $.fn.mbGallery.defaults={
    containment:"body",
    galleryTop:40,
    galleryWidth: 300,
    galleryHeight: 300,
    galleryMaxWidth: 0,
    galleryMaxHeight: 0,
    galleryColor: "#333",
    galleryFrameBorder: 12,
    galleryFrameColor: "#fff",
    maskOpacity:.5,
    maskBgnd:"transparent",

    startFrom: "random",
    headerOpacity: 0.8,
    thumbsBorder: 4,
    thumbHeight: 50,
    thumbStripWidth:250,
    thumbStripColor: "#333333",
    thumbStripPos: "right",
    thumbSelectColor: "black",
    thumbOverColor: "#cccccc",
    imageSelector: ".imgFull",
    thumbnailSelector: ".imgThumb",
    descSelector: ".imgDesc",
    descriptionWidth:300,

    labelColor: "#333",
    labelColorDisactive: "#333",
    labelTextColor: "#fff",
    labelTextSize: "11px",
    labelHeight: 20,

    iconFolder: "elements/white",
    fadeTime: 500,
    autoSlide: true,
    slideTimer: 6000,
    autoSize: true,
    startTimer:0
  };



  jQuery.fn.mb_bringToFront= function(){
    var zi=10;
    $('*').each(function() {
      if($(this).css("position")=="absolute"){
        var cur = parseInt($(this).css('zIndex'));
        zi = cur > zi ? parseInt($(this).css('zIndex')) : zi;
      }
    });
    $(this).css('zIndex',zi+=1);
    return $(this);
  };

})(jQuery);