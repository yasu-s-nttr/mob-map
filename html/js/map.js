var sumple_map = {
    map:null,
    map_container:null,
    init:function(){
        map_container = document.getElementById("div-map");
        map = nttMap(map_container);
    }
}