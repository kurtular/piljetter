window.addEventListener("load",function(){
  document.getElementById("filter-button").addEventListener("click",switchFilter);
});

//show-hide filter div.
function switchFilter(){
    var filter = document.getElementById("filter");
    if(filter.style.display == "none" || filter.style.display == "" ){
        document.querySelector(".fa-caret-down").className="fas fa-caret-up";
        filter.style.display = "block";
    }else{
         filter.style.display = "none";
         document.querySelector(".fa-caret-up").className="fas fa-caret-down";
        }
    };