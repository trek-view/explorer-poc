$(function(){
  options = {
    "autoLoad": true,
      "default": {
          "firstScene": "0",
          "author": "Matthew Petroff",
          "sceneFadeDuration": 1000
      },
      "scenes": {}
  }

  keys = Object.keys(gon.connections);

  for(i=0,l=keys.length;i<l;i++){
    if (i == keys.length - 1) {
      nextKey = keys[0]
    } else {
      nextKey = keys[i+1]
    }
    options.scenes[keys[i]] = {
      "title": gon.connections[keys[i]].photo_id,
      "type": "equirectangular",
      "panorama": "https://backpack-staging-explorer-trekview-org.s3.amazonaws.com/uploads/panoramas/" + gon.photo_id + "/" + gon.connections[keys[i]].photo_id,
      "hotSpots": [
          {
              "type": "scene",
              "text": gon.connections[nextKey].photo_id,
              "sceneId": nextKey
          }
      ]
    }
  }

  pannellum.viewer('panorama', options);
});
