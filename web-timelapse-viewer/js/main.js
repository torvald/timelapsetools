$(document).ready(function(){
   $("#date").change(function () {
      loadNewDate($(this).val());
      $(this).blur();
   })
   $("#hour").change(function () {
      loadNewHour($(this).val());
   })
});

function loadNewDate(date) {
    getVideo(date);
    var hour = $('#hour').val()
    getPicture(date, hour);
    
}

function loadNewHour(hour) {
    var date = $('#date').val();
    getPicture(date, hour);
}


function getVideo(date) {
    $.ajax({
       url:"api.php",
       type:'GET',
       data: "get=video&date="+date,
       success: function(data){
           $('#video').html(data);
       }
    })
}

function getPicture(date, hour) {
    $.ajax({
       url:"api.php",
       type:'GET',
       data: "get=picture&date="+date+"&hour="+hour,
       success: function(data){
           $('#picture').html(data);
       }
    })
}

