$(function(){
    $(document).on('change', '.sort-tours', function (event) {
        setSortParm('tours', event.target.value)
    });

    $(document).on('change', '.sort-tourbooks', function (event) {
        setSortParm('tourbooks', event.target.value)
    });
});