WorkerScript.onMessage = function (msg){
                 var data = msg.data;
                 var option = msg.option;
                 loadplaylist(option, data);
                 WorkerScript.sendMessage({});
             }


function loadplaylist(option, data){
    var obj = JSON.parse(data);
    var list = obj.playlist;
    var model = option.model;

    if (option.renew) model.clear();

    list.forEach(function(item){
                     var prop = new Object();

                     for (var i in item){
                         if (typeof(item[i]) == 'string' || typeof(item[i]) == 'number'){
                             prop[i] = item[i];
                         }
                     }

                     prop.cover_small = item.cover.small;
                     prop.cover_medium = item.cover.medium;
                     prop.cover_square = item.cover.square;
                     prop.cover_large = item.cover.large;

                     model.append(prop);
                 })

    model.sync();
}
