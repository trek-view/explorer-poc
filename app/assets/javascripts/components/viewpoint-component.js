$(function(){
   $(document).on('click', '.viewpoint', function (e) {
       var target = event.target || event.srcElement;
       var photoId = e.target.id.replace('photo-', '');

       $.ajax({
           type: 'POST',
           url: '/api/v1/viewpoints',
           data: {
               viewpoint: {
                   photo_id: photoId
               }
           },
           dataType: "json",
           headers: {
               'api-key': localStorage.getItem('api_token'),
           },
           beforeSend: function(x) {
               if (x && x.overrideMimeType) {
                   x.overrideMimeType("application/j-son;charset=UTF-8");
               }
           },
           success: function(data){
                if (data.viewpoint && typeof data.viewpoint === 'object') {
                    target.innerHTML = data.viewpoint.viewpoint
                }
            },
           failure: function(errMsg) {
               console.log(errMsg);
           }
       })
   })
});