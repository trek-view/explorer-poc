var selectedSceneId = -1;
function onChangeSceneId(sceneId) {
  console.log('====== onChangeSceneId: sceneId: ', sceneId);
  if (sceneId == -1) return;
  $.ajax({
    type: "POST",
    url: '/select_scene?scene_id=' + sceneId
  });
}

function onSelectedScene(sceneId) {
  console.log('====== onSelectedScene: sceneId: ', sceneId);
  if (sceneId == -1) return;
  viewer.loadScene(sceneId);
}

function initGuidebookMapBox(scenes, photos) {
  console.log('==== scenes, photos: ', scenes, photos);
  if (!scenes || !photos) return;
  // Get mapbox_token
  const mapboxTokenDom = document.getElementById('mapbox-token').childNodes;
  L.mapbox.accessToken = mapboxTokenDom[0].data;
  var latlng = L.latLng(
    parseFloat(photos[0]['latitude']),
    parseFloat(photos[0]['longitude'])
  );
  var map = L.mapbox.map('mapbox')
    .setView(latlng, 9)
    .addLayer(L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v11'));

  for (var i=0; i < photos.length; i++) {
    var markerData = {
      scene: scenes[i],
      photo: photos[i]
    };
    console.log('===== markerData: ', markerData);
    
    const markerColor = '#d6eff9';
    const markerHtmlStyles = `
      background-color: ${markerColor};
      background-color: #d6eff9;
      width: 1.25rem;
      height: 1.25rem;
      display: block;
      border-radius: 1.5rem;
      transform: rotate(45deg);
      border: 2px solid #7cb4c6;`;
    const markerIcon = L.divIcon({
      className: "my-custom-pin",
      iconAnchor: [0, 0],
      labelAnchor: [-3, 0],
      popupAnchor: [0, -10],
      html: `<span style="${markerHtmlStyles}" />`
    });

    var marker = L.marker(
      new L.latLng(
        parseFloat(markerData.photo.latitude),
        parseFloat(markerData.photo.longitude)
      ),
      {
        icon: markerIcon,
        data: markerData
    }).bindPopup(markerData.scene.title).addTo(map);
    markers.push(marker);

    // var featureLayer = L.mapbox.featureLayer().addTo(map);
    marker.on('click', function(e) {
      console.log('===== marker click: e: ', e);
      viewer.loadScene(e.target.options.data.scene.id);
    });
  }
}
