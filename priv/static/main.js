function init() {
    fetch_websocket_addr();

    if(!("WebSocket" in window)){  
	$('#status').append('<p><span style="color: red;">websockets are not supported </span></p>');
	$("#navigation").hide();  
    } else {
	$('#status').append('<p><span style="color: green;">websockets are supported </span></p>');
	connect();
    };
    $("#connected").hide(); 	
    $("#content").hide(); 	
};

function fetch_websocket_addr() {
    $.ajax({
	    type: "get",
	    url: "/websock_req",
	    dataType: "json",
	    async: false,
	    success: function(data) {
		window.ws_addr = data.websocket;
	    }});
};

function connect() {
    websocket = new WebSocket(ws_addr);
    showScreen('<b>Connecting to: ' + ws_addr + '</b>'); 
    websocket.onopen = function(evt) { onOpen(evt) }; 
    websocket.onclose = function(evt) { onClose(evt) }; 
    websocket.onmessage = function(evt) { onMessage(evt) }; 
    websocket.onerror = function(evt) { onError(evt) }; 
};  
      
function disconnect() {
    websocket.close();
}; 

function toggle_connection(){
    if(websocket.readyState == websocket.OPEN){
	disconnect();
    } else {
	connect();
    };
};

function sendTxt() {
    if(websocket.readyState == websocket.OPEN){
	var message = new Object();
        message.action = "send_msg";
        message.message = $("#send_txt").val();
	websocket.send(JSON.stringify(message));
    } else {
	showScreen('websocket is not connected'); 
    };
};

function onOpen(evt) { 
    showScreen('<span style="color: green;">CONNECTED </span>'); 
    $("#connected").fadeIn('slow');
    $("#content").fadeIn('slow');
};  

function onClose(evt) { 
    showScreen('<span style="color: red;">DISCONNECTED </span>');
};  

function onMessage(evt) { 
    var msg = $.parseJSON(evt.data);
    showScreen('<span style="color: blue;">' + msg.from + ': ' + msg.message + '</span>'); 
};  

function showScreen(txt) { 
    $('#output').prepend('<p>' + txt + '</p>');
};

function clearScreen() { 
    $('#output').html("");
};
