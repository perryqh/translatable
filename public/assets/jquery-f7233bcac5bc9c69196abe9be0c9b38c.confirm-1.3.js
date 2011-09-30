/**
 * Confirm plugin 1.3
 *
 * Copyright (c) 2007 Nadia Alramli (http://nadiana.com/)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */
/**
 * For more docs and examples visit:
 * http://nadiana.com/jquery-confirm-plugin
 * For comments, suggestions or bug reporting,
 * email me at: http://nadiana.com/contact/
 */
jQuery.fn.confirm=function(a){a=jQuery.extend({msg:"Are you sure?",stopAfter:"never",wrapper:"<span></span>",eventType:"click",dialogShow:"show",dialogSpeed:"",timeout:0},a),a.stopAfter=a.stopAfter.toLowerCase(),!a.stopAfter in["never","once","ok","cancel"]&&(a.stopAfter="never"),a.buttons=jQuery.extend({ok:"Yes",cancel:"No",wrapper:'<a href="#"></a>',separator:"/"},a.buttons);var b=a.eventType;return this.each(function(){var c=this,d=jQuery(c),e,f=function(){var a=jQuery.data(c,"events");if(!a&&c.href)d.bind("click",function(){document.location=c.href}),a=jQuery.data(c,"events");else if(!a)return;c._handlers=[];for(var e in a[b])c._handlers.push(a[b][e])},g=jQuery(a.buttons.wrapper).append(a.buttons.ok).click(function(){return a.timeout!=0&&clearTimeout(e),d.unbind(b,j),d.show(),i.hide(),c._handlers!=undefined&&jQuery.each(c._handlers,function(){d.click(this.handler)}),d.click(),a.stopAfter!="ok"&&a.stopAfter!="once"&&(d.unbind(b),d.one(b,j)),!1}),h=jQuery(a.buttons.wrapper).append(a.buttons.cancel).click(function(){return a.timeout!=0&&clearTimeout(e),a.stopAfter!="cancel"&&a.stopAfter!="once"&&d.one(b,j),d.show(),i.hide(),!1});a.buttons.cls&&(g.addClass(a.buttons.cls),h.addClass(a.buttons.cls));var i=jQuery(a.wrapper).append(a.msg).append(g).append(a.buttons.separator).append(h),j=function(){return jQuery(this).hide(),a.dialogShow!="show"&&i.hide(),i.insertBefore(this),i[a.dialogShow](a.dialogSpeed),a.timeout!=0&&(clearTimeout(e),e=setTimeout(function(){h.click(),d.one(b,j)},a.timeout)),!1};f(),d.unbind(b),c._confirm=j,c._confirmEvent=b,d.one(b,j)})}