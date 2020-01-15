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
      "hfov": 0,
      "pitch": parseInt(gon.connections[keys[i]].pitch_degrees) || 0,
      "yaw": parseInt(gon.connections[keys[i]].heading_degrees) || 0,
      "type": "equirectangular",
      "panorama": "https://backpack-staging-explorer-trekview-org.s3.amazonaws.com/uploads/panoramas/" + gon.photo_id + "/" + gon.connections[keys[i]].photo_id,
      "hotSpots": [
          {
              "type": "scene",
              "hfov": 0,
              "pitch": parseInt(gon.connections[nextKey].pitch_degrees) || 0,
              "yaw": parseInt(gon.connections[nextKey].heading_degrees) || 0,
              "text": gon.connections[nextKey].photo_id,
              "sceneId": nextKey
          }
      ]
    }
  }

  pannellum.viewer('panorama', options);
});
