// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

var selectedPhotoId = -1;
function onChangePhotoId(photoId) {
  $.ajax({
    type: "GET",
    url: '/select_scene_photo?photo_id=' + photoId
  });
}