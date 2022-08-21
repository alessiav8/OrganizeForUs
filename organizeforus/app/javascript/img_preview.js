function validate_and_preview() {
  var maxFileSize = $('#imgInp').data('max-file-size');
  var maxExceededMessage = "This file exceeds the maximum allowed file size (5 MB)";
  console.log('ok');
  if ($('#imgInp').val().length === 0) {
    $('#imgArrow').hide();
    $('#imgOut').hide();
    console.log('A');
  } else if ($("#imgInp").prop('files')[0].size < parseInt(maxFileSize)) {
    $('#imgArrow').show();
    $('#imgOut').show();
    console.log('B');
    const imgOut = $('#imgOut');
    const imgArrow = $('#imgArrow');
    const file = $("#imgInp").prop('files')[0];
    if (file) {
      var reader = new FileReader();
      console.log(file);

      $('#imgOut').attr('src', (window.URL || window.webkitURL).createObjectURL(file));
      console.log('ok');
    }
    console.log('ok');
  } else {
    window.alert(maxExceededMessage);
    $('#imgInp').val('');
    $('#imgArrow').hide();
    $('#imgOut').hide();
  }
  console.log('ok');
}

export { validate_and_preview }