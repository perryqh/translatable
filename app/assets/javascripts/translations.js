$(function() {
  $(document).ready(function() {
    $('.editable').editable();
    $('select#locale').observeLocale();
  });

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
});
