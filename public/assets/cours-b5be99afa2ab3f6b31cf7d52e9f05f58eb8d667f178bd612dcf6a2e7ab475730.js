(function() {
  $(document).on('turbolinks:load', function() {
    return $('#check_all_trigger').change(function() {
      console.log("Check_all_trigger changed to: ", this.checked);
      if (this.checked) {
        return $(".check_all").each(function() {
          return this.checked = true;
        });
      } else {
        return $(".check_all").each(function() {
          return this.checked = null;
        });
      }
    });
  });

}).call(this);
