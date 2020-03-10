// 'use strict';

function initMap(objects) {
    var myCoords = new google.maps.LatLng(objects[0]['latitude'], objects[0]['longitude']);
    var mapOptions = {
        center: myCoords,
        streetViewControl: false,
        zoom: 15
    };

    var map = new google.maps.Map(document.getElementById('map'), mapOptions);

    for (var i=0; i < objects.length; i++){
        var markerData = objects[i];
        var latLng = new google.maps.LatLng(markerData.latitude, markerData.longitude);

        var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            animation: google.maps.Animation.DROP,
            photo: objects[i]
        });

        google.maps.event.addListener(marker, 'click', function() {
            showThumbModal(this.photo);
        });
    }
}

function initTourMapBox(photos) {
    if (!photos) return;
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
      }).bindPopup(markerData.photo.tourer_photo_id).addTo(map);

      marker.on('click', function(e) {
        console.log('===== marker click: e: ', e);
        showThumbModal(this.photo);
      });
    }
}

function initElevationChart(data, photos) {
    var chartData = [];
    for (var key in data) {
        if (data.hasOwnProperty(key)) {
            chartData.push([Date.parse(key), data[key]]);
        }
    }

    $('#elevation-chart-container').highcharts({
        chart: {
            type: 'scatter',
            zoomType: 'xy'
        },
        title: {
            text: ''
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            tickInterval: (24 * 3600 * 1000), // the number of milliseconds in a day
            allowDecimals: false,
            title: {
                text: 'Date',
                scalable: false
            },
            type: 'datetime',
            labels: {
                formatter: function() {
                    return Highcharts.dateFormat('%d-%b-%y', (this.value));
                }
            }
        },
        yAxis: {
            title: {
                text: 'Elevation Meter'
            }
        },
        series: [{
            "name": "Elevation Change",
            "data": chartData
        }],
        plotOptions: {
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function () {
                            // alert('Category: ' + this.category + ', value: ' + this.y);
                            for (var i = 0; i < photos.length; i++) {
                                var p = photos[i];
                                if (milisecondsToDatetime(p.taken_at) === milisecondsToDatetime(this.category)) {
                                    return showThumbModal(p);
                                }
                            }
                        }
                    }
                }
            }
        },
        tooltip: {
            formatter: function() {
                return new Date(this.x).toLocaleDateString()  + ': ' + this.y;
            }
        }

    });
}

function milisecondsToDatetime(miliseconds) {
    return new Date(miliseconds).toLocaleTimeString()
}

function text_truncate(str, length, ending) {
    if (length == null) {
      length = 100;
    }
    if (ending == null) {
      ending = '...';
    }
    if (str.length > length) {
      return str.substring(0, length - ending.length) + ending;
    } else {
      return str;
    }
  };
function showThumbModal(photo) {
    if (photo
        && photo.image
        && photo.image.thumb
        && photo.streetview
    ) {
        favorite_score = photo.favoritable_score.favorite || 0
        $('#imageContainer').empty();
        $('.modal-title').prepend(text_truncate(photo.filename, 40));
        $('#imageContainer').prepend(
            '<span class="viewpoint" data-photo-id="' +
            photo.id + '"><i class="fa fa-star"></i><span>' +
            favorite_score + '</span></span><a href="/photos/' +
            photo.id +'"><img id="photoImg" src="' +
            photo.image_thumb_path +
            '" style="width: 100%" /><div class="card-body"><p class="card-text">Latitude: ' +
            photo.latitude + '</p><p class="card-text">Longitude: ' +
            photo.longitude + '</p><p class="card-text">Photo elevation: ' +
            photo.elevation_meters + '</p><p class="card-text">Capture time: ' +
            photo.taken_at + '</p></div></a>'
        );

        $('#showPhotoModal').modal('show');
    }
    return;
}
