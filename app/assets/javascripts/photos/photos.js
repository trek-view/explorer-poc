$(function(){
    $(document).on('change', '.sort-photos', function (event) {
        setSortParm('photos', event.target.value)
    });
});