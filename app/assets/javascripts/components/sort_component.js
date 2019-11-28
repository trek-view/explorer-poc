$(function(){

    $(document).on('change', '.select-sort-by', function(event){
        console.log('sort by', event.target.value);

        let url = new URL(location.href);
        console.log('url', url);
        if(location.href.indexOf('sort_by') === -1) {
            url.searchParams.append('sort_by', event.target.value);
            return location.href = url.href;
        }
        url.searchParams.set('sort_by', event.target.value);
        location.href = url.href;
    });
});