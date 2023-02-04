Qt.include("Storage.js")
Qt.include("JsonFormatter.js")

var DATA_SET;
var PAGE_COUNT=1;
var HB_REQ,COMMON_REQ;
var FUNC;

function getBaseUrl(){
    //return "http://192.168.1.44/cef/public/index.php/api";
    return control_bord.getConfigValue("base_url","http://52.91.200.177/public/index.php/api")
}

function startTimer(xmlhttp,seconds){
    COMMON_REQ=xmlhttp;
    timer.interval=seconds;
    timer.running = true;
}

function retrieveLoacalData(){
    root.state = "main"
    console.log('time out fired.calling local db .....')
}


//calling API 1
function syncDB(){
    root.state="wait"
    //http://clube.sysdek.com/public/index.php/api/auth?id=2&accessCode=446110805b1d400b952c56a19e9ecf53ef94ea7e
    var xmlhttpURL=getBaseUrl() + '/auth?id='+ control_bord.getDeviceID() +'&accessCode=' + control_bord.getAccessCode()
    console.log(xmlhttpURL)
    var xmlhttp = new XMLHttpRequest();
    startTimer(xmlhttp,(2*60*1000));
    FUNC="syncdb";

    xmlhttp.onreadystatechange = function() {
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
            timer.running = false;
            console.log("working ....")
            try{
                if(xmlhttp.responseText){
                    setUserDetails(JSON.parse(xmlhttp.responseText));
                }
                else
                    errorDisplay("SORRY (code:SDB-1)","Can not get request data");
            }
            catch(err){
                errorDisplay("EXCEPTION (code:SDB-ex)","Can not get request data");
                console.log(err)
            }
        }
    }
    xmlhttp.open("GET",xmlhttpURL,true);
    xmlhttp.send(null);
    //dbBatchUpdate();
}

function redeemItem(){
    root.state="wait"
    //http://clube.sysdek.com/public/index.php/api/redeem?id=2&accessCode=446110805b1d400b952c56a19e9ecf53ef94ea7e&cc='+ card_code +'&couponId='+ item_id +'
    var xmlhttpURL=getBaseUrl() + '/redeem?id='+ control_bord.getDeviceID() +'&accessCode='+ control_bord.getAccessCode() +'&cc='+ card_code +'&couponId=' + item_view.item_id
    var xmlhttp = new XMLHttpRequest();
    startTimer(xmlhttp,5000);
    FUNC="redeem";

    xmlhttp.onreadystatechange = function() {
     if (xmlhttp.readyState)
     {
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
            timer.running = false;

            try{
                if(xmlhttp.responseText){
                    DATA_SET=JSON.parse(xmlhttp.responseText);
                    if(DATA_SET.status == 1 && DATA_SET.error.code === 204){
                        errorDisplay("SORRY",DATA_SET.error.message);
                        screen_name="main"
                    }
                    else{
                        updateCusPromoRedeem(card_code,item_view.item_id,'1');
                        idle_seconds=5;
                        root.state = "redeemed";
                    }
                }
                else
                    errorDisplay("SORRY","CAN NOT GET REQUEST DATA");
            }
            catch(err){
                errorDisplay("ERROR","CAN NOT GET REQUEST DATA");
            }
        }
     }
    }
    xmlhttp.open("GET",xmlhttpURL,true);
    xmlhttp.send(null);
    //localRedeemItems(card_code,item_view.item_id);
}

function localRedeemItems(){
    try{
        var rs=updateCusPromoRedeem(card_code,item_view.item_id,'1');
        if(rs.rowsAffected === 0){
            errorDisplay("SORRY","CAN NOT UPDATE LOCAL DATA");
            screen_name="main"
        }
        else{
            idle_seconds=5;
            root.state = "redeemed";
        }
    }
    catch(err){
        errorDisplay("EXCEPTION (code:LRI-ex)","CAN NOT UPDATE LOCAL DATA")
    }
}


function cashPoints(){
    root.state="wait"
    //'http://clube.sysdek.com/public/index.php/api/cashpoints?id=2&accessCode=446110805b1d400b952c56a19e9ecf53ef94ea7e&cc=0003951317&amount=60'
    var xmlhttpURL=getBaseUrl() +'/cashpoints?id='+ control_bord.getDeviceID() +'&accessCode='+ control_bord.getAccessCode() +'&cc='+ card_code +'&amount=' + pin_page.points
    //console.log(xmlhttpURL)

    var xmlhttp = new XMLHttpRequest();
    startTimer(xmlhttp,5000);
    FUNC="cash";

    xmlhttp.onreadystatechange = function() {
     if (xmlhttp.readyState)
     {
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
            timer.running = false;
            console.log("working ......")
            try{
                if(xmlhttp.responseText){
                    DATA_SET=JSON.parse(xmlhttp.responseText);
                    if(DATA_SET.status == 1 && DATA_SET.error.code === 204){
                        errorDisplay("SORRY",DATA_SET.error.message);
                        screen_name="main"
                    }
                    else{
                        addCashPoints(card_code,pin_page.points);
                        success_screen.amount_txt='RS' + ' ' + pin_page.points + '/='
                        idle_seconds=2
                        root.state="success"
                        screen_name="outlet"
                    }
                }
                else
                    errorDisplay("SORRY (code:CP-1)","CAN NOT GET REQUEST DATA");
            }
            catch(err){
                errorDisplay("EXCEPTION (code:CP-ex)","CAN NOT SYNC FROM API");
            }
        }
     }
    }
    xmlhttp.open("GET",xmlhttpURL,true);
    xmlhttp.send(null);
}

function loacaCashPoints(){
    try{
        var rs = addCashPoints(card_code,pin_page.points);
        if(rs.rowsAffected === 0){
            errorDisplay("SORRY","CAN NOT UPDATE LOCAL DATA");
            screen_name="main"
        }
        else{
            success_screen.amount_txt='RS' + ' ' + pin_page.points + '/='
            idle_seconds=2
            root.state="success"
            screen_name="outlet"
        }
    }
    catch(err){
        errorDisplay("EXCEPTION (code:LCP-ex)","CAN NOT ADD TO LOCAL DB");
        console.log(err);
    }
}

function errorDisplay(t1,t2){
    erorr_view.error_text1.text=t1;
    erorr_view.error_text2.text=t2;
    idle_seconds=2
    root.state="error";
}

//calling API 2
function authenticateUser(){
    var xmlhttpURL=getBaseUrl() + '/swipe?id='+ control_bord.getDeviceID() +'&accessCode='+ control_bord.getAccessCode() +'&cc=' + card_code
    console.log(xmlhttpURL)
    var xmlhttp = new XMLHttpRequest();
    startTimer(xmlhttp,5000);
    FUNC="auth";

    xmlhttp.onreadystatechange = function() {
         if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
         {
             timer.running = false;
             try{
                 var data_set=JSON.parse(xmlhttp.responseText);
                 //var data_set=jsonCreator()
                 authEventHandler(data_set);

             }
             catch(err){
                 errorDisplay("EXCEPTION (code:API2-ex)",err.toString());
                 }
             }
        }
    xmlhttp.open("GET",xmlhttpURL,true);
    xmlhttp.send(null);
}

function localAuth(){
    try{
        var data_set=localAuthenticateUser(card_code);
        authEventHandler(data_set);
    }
    catch(err){
        errorDisplay("EXCEPTION (code:Local-auth-ex)",err.toString());
        console.log(err);
    }
}

function authEventHandler(data_set){
    try{
        if(data_set.error.code != 200){
            //console.debug("Server Logical Error"+data_set.error.message)
            errorDisplay("SORRY",data_set.error.message);
            return;
        }

        if (data_set.data.Users === "" && data_set.data.Users.CusPromoRedeems === ""){
            errorDisplay("SORRY","PLEASE SWIPE YOUR CARD AGAIN");
            return
        }


        DATA_SET=data_set.data.Users.CusPromoRedeems;
        event_id=data_set.eventId

        if(data_set.eventId === "0"){
            if( data_set.data.Users.pin.length > 0){
               console.log('l1')
               root.pin_code=data_set.data.Users.pin;
               idle_seconds=5
               outlet_screen.pinRequired=(data_set.ispinRequired === 1)
               root.state="outlet";
            }
            else if(data_set.ispinRequired === 0){
                console.log('l2')
                idle_seconds=5
                outlet_screen.pinRequired=(data_set.ispinRequired === 1)
                root.state="outlet";
            }
            else
                errorDisplay("SORRY (code:API2-1)","PLEASE SWIPE YOUR CARD AGAIN");
        }
        else if(data_set.ispinRequired === 0){
            root.state = "wait"
            API_call.loadItemList()
        }
        else if(data_set.ispinRequired === 1 && data_set.data.Users.pin !== null && data_set.eventId === "0"){
            //con
            root.pin_code=data_set.data.Users.pin;
            pin_page_type='enter_pin';
            setPinPage("ENTER YOUR 4 DIGIT PIN","SUBMIT","CANCEL");
            idle_seconds=5
            root.state="pin";
        }
        else{
            errorDisplay("SORRY (code:API2-2)","PLEASE SWIPE YOUR CARD AGAIN");
        }
    }
    catch(err){
        errorDisplay("EXCEPTION (code:API2-ex)",err.toString());
        console.log(err);
        }
}

function setPinPage(t1,t2,t3){
    pin_page.pin_page_txt=t1;
}

function jsonFormatterForAPI2Local(rs){
    try{
        var CUS_PROMO = {
            CusPromoRedeems: []
        };

        for(var i=0;i<rs.rows.length;i++) {
            CUS_PROMO.CusPromoRedeems.push({
                "cus_promo_redeems_id" : rs.rows.item(i).cus_promo_redeems_id,
                "promotion_id"  : rs.rows.item(i).promotion_id
            });
        }
        return (JSON.parse(JSON.stringify(CUS_PROMO))).CusPromoRedeems;
    }
    catch(err){
        errorDisplay("ERROR","CAN NOT GET LOCAL DATA");
    }
}

function loadItemList(){
    try{
        if(Math.ceil(DATA_SET.length/4) > 0){
            item_list.data_set=DATA_SET;
            item_list.page_count=Math.ceil(DATA_SET.length/4)
            item_list.list_view_loader.sourceComponent = item_list.grid_com;
            item_list.cur_page=0
            item_list.page_num=(item_list.cur_page + 1) + "/" + item_list.page_count
            idle_seconds=30
            root.state = "item_list_set";
        }
        else{
            errorDisplay("SORRY","NO AVAILABLE COUPON");
        }
    }
    catch(err){
        errorDisplay("ERROR","CAN NOT LOAD COUPON LIST");
    }
}

function dbBatchUpdate(){
    try{
        var rs=getChangedCusProRedeems();
        var rs1=getCashPoints()

        var batch_update = {
            CusPromoRedeems: [],
            MerchantCashRewards: []
        };

        for(var i=0;i<rs.rows.length;i++) {
            batch_update.CusPromoRedeems.push({
                "card_code" : rs.rows.item(i).card_code,
                "cus_promo_redeems_id"  : rs.rows.item(i).cus_promo_redeems_id,
                "promotion_id"  : rs.rows.item(i).promotion_id
            });
        }

        for(var c=0;c<rs1.rows.length;c++) {
            batch_update.MerchantCashRewards.push({
                "card_code" : rs1.rows.item(c).card_code,
                "amount"  : rs1.rows.item(c).amount,
                "rew_points"  : "6"
            });
        }
        testSync(batch_update);
    }
    catch(err){
        errorDisplay("ERROR","CAN NOT GET LOCAL DATA");
    }
}

function testSync(json_obj){
    root.state="wait"
    //http://clube.sysdek.com/public/index.php/api/auth?id=2&accessCode=446110805b1d400b952c56a19e9ecf53ef94ea7e
    var xmlhttpURL=getBaseUrl() + '/batchupdate?id='+ control_bord.getDeviceID() +'&accessCode=' + control_bord.getAccessCode()
    //console.log(xmlhttpURL)
    var xmlhttp = new XMLHttpRequest();
    //startTimer(xmlhttp,10000);

    xmlhttp.onreadystatechange = function() {
     if (xmlhttp.readyState)
     {
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
            //timer.running = false;

            try{
                console.log((JSON.parse(xmlhttp.responseText)).status);
            }
            catch(err){
                errorDisplay("ERROR","CAN NOT SYNC FROM API");
                console.log(err)
            }
        }
     }
    }
    xmlhttp.open("POST",xmlhttpURL,true);
    xmlhttp.setRequestHeader('Content-type','application/json');
    xmlhttp.send(JSON.stringify(json_obj));
}

function heartBeat(){
    var xmlhttpURL=getBaseUrl() + '/heartbeat?id='+ control_bord.getDeviceID() +'&accessCode=' + control_bord.getAccessCode()
    console.log(xmlhttpURL)
    var xmlhttp = new XMLHttpRequest();
    HB_REQ=xmlhttp;

    xmlhttp.onreadystatechange = function() {
     if (xmlhttp.readyState)
     {
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){

            try{
                var data_set=JSON.parse(xmlhttp.responseText);
                if(data_set.error.code != 200){
                    errorDisplay("SORRY",data_set.error.message);
                    return;
                }
                else
                    console.log("working .....")
            }
            catch(err){
                errorDisplay("ERROR","CAN NOT SYNC FROM API");
                console.log(err)
            }
        }
     }
    }
    xmlhttp.open("GET",xmlhttpURL,true);
    xmlhttp.timeout = 2;
    xmlhttp.ontimeout = function () {
        console.log("The request for timed out.");
      };
    xmlhttp.send(null);
}

function jsonCreator(){
    var val='{"status":1,"ispinRequired":"1","eventId":"0","cashToPointRatio":"0.100","data":{"Users":{"user_id":"6","card_code":"0002216296","username":"saman@ymail.com","pin":"1234","user_image":"0","first_name":"Saman","last_name":"","addr_line1":null,"addr_line2":null,"addr_city":null,"addr_sate_province":null,"addr_postal_code":null,"addr_country":null,"phone":null,"email":"saman@ymail.com","status":"0","CusPromoRedeems":[{"cus_promo_redeems_id":"79","promotion_id":"4","promo_name":"Radio Star","promo_description":"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit"}]}},"dataCount":17,"error":{"code":"","message":""}}'
    return JSON.parse(val)
}
