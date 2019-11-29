$(function(){
    $(document).on('change', '.sort-tours', function (event) {
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
    let url = new URL(location.href);
    const uri = window.decodeURI(location.href);

    if(uri.indexOf(`sort[${collection}]`) === -1) {
        url.searchParams.append(`sort[${collection}]`, value);
        return location.href = url.href;
    }

    url.searchParams.set(`sort[${collection}]`, value);
    location.href = url.href;
}