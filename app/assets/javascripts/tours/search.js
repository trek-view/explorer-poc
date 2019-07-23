'use strict';

$(function(){

    $(document).on('change', '.search-text-input, .select-country, .select-tour-type', function(){
        submitTourSearch();
    });

});

function submitTourSearch() {
    var form = $('form.index-search-form');
    var valuesToSubmit = form.serialize();

    $.ajax({
        url: '/search_tours',
        method: 'GET',
        data: valuesToSubmit,
        success: function (response) {
            var container = $('.tours-container');
            container.html(response);
        }
    });
    return false;
}