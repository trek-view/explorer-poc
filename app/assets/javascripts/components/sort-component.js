console.log('sort-component.js');
$(function(){
    $(document).on('change', '.sort-tours', function (event) {
        console.log('sort tours changed');
        setSortParm('tours', event.target.value)
    });

    $(document).on('change', '.sort-tourbooks', function (event) {
        setSortParm('tourbooks', event.target.value)
    });

    $(document).on('change', '.sort-photos', function (event) {
        setSortParm('photos', event.target.value)
    });
});

function setSortParm(collection, value) {
    var url = new URL(location.href);
    var uri = window.decodeURI(location.href);

    var prm = "sort[" + collection + "]";
    if (uri.indexOf(prm) === -1) {
        url.searchParams.append(prm, value);
        return location.href = url.href;
    }

    url.searchParams.set(prm, value);
    location.href = url.href;
}