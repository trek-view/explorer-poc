// 'use strict';

function initMap(objects) {
    var myCoords = new google.maps.LatLng(objects[0]['latitude'], objects[0]['longitude']);
    var mapOptions = {
        center: myCoords,
        zoom: 8
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

function initElevationChart(data, photos) {
    const chartData = [];
    for (const key in data) {
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
                            const photo = photos.find(p => (
                                milisecondsToDatetime(p.taken_at) === milisecondsToDatetime(this.category)
                            ));
                            showThumbModal(photo);
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

function showThumbModal(photo) {
    if (photo
        && photo.image
        && photo.image.thumb
        && photo.streetview) {
        $('#imageContainer').empty();
        $('#imageContainer').prepend('<a href="' + photo.streetview.share_link + '" target="_blank"><img id="photoImg" src="' + photo.image.thumb.url + '" style="width: 100%" /></a>');
        $('#showPhotoModal').modal('show');
    }
    return;
}
