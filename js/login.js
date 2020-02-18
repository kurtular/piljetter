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