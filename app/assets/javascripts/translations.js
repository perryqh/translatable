$(function() {
  $(document).ready(function() {
    $('.editable').editable();
    $('select#locale').observeLocale();
    $('a.destroy-translation').destroyTranslation();
  });

  $.fn.destroyTranslation = function() {
    $(this).click(function() {
      var parentRow = $(this).parents('tr.row');
      var ajaxOptions = {
        type: 'delete',
        url: $(this).attr('data-url'),
        data: { key: $(this).attr('data-key')},
        success: function(response) {
          parentRow.slideUp();
        }
      };
      $.ajax(ajaxOptions);
      return false;
    });

    $(this).confirm({
      msg: 'Are you sure you want to delete this translation?',
      timeout: 10000
    });
  };

  $.fn.editable = function() {
    $(this).inlineEdit({
      save: function(e, data) {
        var ajaxOptions = {
          type: 'post',
          url: $(this).attr('data-url'),
          data: { '_method': 'put', key: $(this).attr('data-key'), value: data.value },
          success: function(response) {

          }
        };
        $.ajax(ajaxOptions);

        return confirm('Change value to '+ data.value +'?');
      }
    });
  };

  $.fn.observeLocale = function() {
    $(this).change(function() {
      $(this).parents('form').submit();
    });
  }

  $("body").bind("click", function (e) {
  $('.dropdown-toggle, .menu').parent("li").removeClass("open");
  });
  $(".dropdown-toggle, .menu").click(function (e) {
    var $li = $(this).parent("li").toggleClass('open');
    return false;
  });

$("#translations").tablesorter( {sortList: [[1,0]]} );
});
