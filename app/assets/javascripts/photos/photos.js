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

  if(typeof gon.connections == 'undefined') {
    return false
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
      "pitch": parseFloat(gon.connections[keys[i]].pitch_degrees) || 0,
      "yaw": parseFloat(gon.connections[keys[i]].heading_degrees) || 0,
      "type": "equirectangular",
      "panorama": gon.connections[keys[i]].url,
      "hotSpots": [
          {
              "type": "scene",
              "hfov": 0,
              "pitch": parseFloat(gon.connections[nextKey].pitch_degrees) || 0,
              "yaw": parseFloat(gon.connections[nextKey].heading_degrees) || 0,
              "text": gon.connections[nextKey].photo_id,
              "sceneId": nextKey
          }
      ]
    }
  }

  console.log(options)

  pannellum.viewer('panorama', options);
});
