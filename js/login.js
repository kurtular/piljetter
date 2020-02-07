
document.querySelector("#login_form button[type='submit']").onclick = function(e){
    if(isRequiredDone(document.querySelectorAll("#login_form input[required]"))){
    e.preventDefault();}
};
document.querySelector("#reg_form button[type='submit']").onclick = function(e){
    if(isRequiredDone(document.querySelectorAll("#reg_form input[required]"))){
    e.preventDefault();}
};
function isRequiredDone(elements){
    var returned = true;
    elements.forEach(element => {
        if(element.value ==""){
        returned = false;
        }
    });
    return returned;
}
function show(page){
    var form = document.querySelector("form"); 
    switch(page){
        case "log":
        document.getElementById("reg_form").style.display="none";
        document.getElementById("login_form").style.display="block";
        document.title="Inloggning";break;
        
        case "reg":
        document.getElementById("login_form").style.display="none";
        document.getElementById("reg_form").style.display="block";
        document.title="Registrering";break;
        default:console.log("stop doing that");
        
    }
}