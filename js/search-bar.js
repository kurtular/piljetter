window.addEventListener("load",function(){
  document.getElementById("filter-button").addEventListener("click",switchFilter);

  document.querySelectorAll("header select ,header input").forEach(input=>{input.addEventListener("input",search);});
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
    }
    
function search(){
  if(isSearching){
    console.log("yes");
  }
  else{
  reloadContent();
  }
}
function isSearching(){
  var returned = false;
  document.querySelectorAll("header select ,header input").forEach(input=>{if(input.value!="")returned=true;});
  return returned;
}