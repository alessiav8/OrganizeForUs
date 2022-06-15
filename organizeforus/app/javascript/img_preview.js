let Preview = {
  img_preview: function() {
    imgInp = $(document).getElementById("imgInp");
    const imgOut = $(document).getElementsById("imgOut");
    const [file] = imgInp.files;
    if (file) {
    imgOut[0].hidden = false;
    imgOut[1].src = URL.createObjectURL(file);
    imgOut[1].hidden = false;
    }
  },

  setup: function() {
    if ($(this).file.length === 0) {
      $('.imgOut').hide();
    } else {
      $('.imgOut').show();
      img_preview();
    }
  }
}

Preview.setup();