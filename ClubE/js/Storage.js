function getDatabase(){
    return openDatabaseSync("ClubEDB", "1.0", "ClubE Offline Database", 1000000);
}

function setUserDetails(json_array){
    console.log('storage ....')
    var db = getDatabase();
    db.transaction(
                function(tx){
                    try{
                        console.log('db loading .....')
                        var c=0
                        tx.executeSql('DROP TABLE IF EXISTS clube_CusPromoRedeems')
                        tx.executeSql('DROP TABLE IF EXISTS clube_user')
                        tx.executeSql('DROP TABLE IF EXISTS clube_promotion')
                        tx.executeSql('DROP TABLE IF EXISTS clube_CusCashPoints')
                        tx.executeSql('DROP TABLE IF EXISTS clube_UserAction')

                        tx.executeSql('CREATE TABLE IF NOT EXISTS clube_promotion(promotion_id INTEGER PRIMARY KEY, promo_image TEXT, promo_name TEXT, promo_description TEXT)');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS clube_user(user_id INTEGER PRIMARY KEY, card_code varchar(50), pin varchar(50))');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS clube_CusPromoRedeems(CPR_ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id int NOT NULL, cus_promo_redeems_id int, promotion_id int NOT NULL, flag int DEFAULT 0, FOREIGN KEY (user_id) REFERENCES clube_user(user_id), FOREIGN KEY (promotion_id) REFERENCES clube_promotion(promotion_id))');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS clube_CusCashPoints(CCP_ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id int NOT NULL, amount varchar(10), flag int DEFAULT 0, FOREIGN KEY (user_id) REFERENCES clube_user(user_id))');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS clube_UserAction(UA_ID INTEGER PRIMARY KEY AUTOINCREMENT, user_id int NOT NULL, status int, ispinRequired int, eventId varchar(2), cashToPointRatio varchar(10), code int, message varchar(50), FOREIGN KEY (user_id) REFERENCES clube_user(user_id))');


                        //console.log(json_array.data.promotions[4].promo_image)
                        for(c=0;c < json_array.data.promotions.length;c++){
                            var image_path='promo_' + json_array.data.promotions[c].promotion_id + '.png';
                            if(json_array.data.promotions[c].promo_image === "")
                                image_path='nodataavailable.png';
                            else
                                control_bord.saveImages(json_array.data.promotions[c].promo_image, 'promo_' + json_array.data.promotions[c].promotion_id);
                            tx.executeSql('INSERT INTO clube_promotion (promotion_id,promo_image,promo_name,promo_description) VALUES(?, ?, ?, ?)', [json_array.data.promotions[c].promotion_id, image_path, json_array.data.promotions[c].promo_name, json_array.data.promotions[c].promo_description]);
                        }

                        for(c=0;c < json_array.data.Users.length;c++){

                            tx.executeSql('INSERT INTO clube_user (user_id,card_code,pin) VALUES(?, ?, ?)', [json_array.data.Users[c].user_id, json_array.data.Users[c].card_code, json_array.data.Users[c].pin]);
                            tx.executeSql('INSERT INTO clube_UserAction (user_id,status,ispinRequired,eventId,cashToPointRatio,code,message) VALUES(?, ?, ?, ?, ?, ?, ?)', [json_array.data.Users[c].user_id, json_array.status, json_array.ispinRequired, json_array.eventId, json_array.cashToPointRatio, json_array.error.code, json_array.error.message]);
                            if(json_array.data.Users[c].CusPromoRedeems.length){
                                for(var c1 = 0;c1 < json_array.data.Users[c].CusPromoRedeems.length; c1++){
                                    tx.executeSql('INSERT INTO clube_CusPromoRedeems(user_id,cus_promo_redeems_id,promotion_id) VALUES(?, ?, ?)', [json_array.data.Users[c].user_id, json_array.data.Users[c].CusPromoRedeems[c1].cus_promo_redeems_id, json_array.data.Users[c].CusPromoRedeems[c1].promotion_id]);
                                }
                        }
                        }
                        console.log('db ready .....')
                        root.state = "main";
                    }
                    catch(err){
                        //error_text1.text="SORRY (code:SDB-ex)"
                        //error_text2.text="Local Database Failure"
                        //root.state="error"
                        console.log(err)
                    }
                }

                )
}

function getItemDec(p_id){
    var db = getDatabase();
    var data = "data\nnot\navailable"
    db.transaction(
                function(tx){
                    try{
                        var rs = tx.executeSql("SELECT * FROM clube_promotion where promotion_id='"+ p_id +"'");
                        data=rs.rows.item(0).promo_name;
                    }
                    catch(err){
                        //console.log(err)
                    }
                }

                )
    return data;
}

function getImage(p_id){
    var db = getDatabase();
    var data = "data\nnot\navailable"
    db.transaction(
                function(tx){
                    try{
                    var rs = tx.executeSql("SELECT * FROM clube_promotion where promotion_id='"+ p_id +"'");
                    if(control_bord.isDevice())
                        data='file:/home/ranjana/clube_pro/ClubE/coupon_images/' + rs.rows.item(0).promo_image;
                    else
                        data='file:/home/root/test/' + rs.rows.item(0).promo_image;
                    }
                    catch(err){
                        data="qrc:/res/nodataavailable.png";
                    }
                }
                )
    return data;
}

function getCusPromo(){
    var db = getDatabase();
    var rs = "data\nnot\navailable"
    db.transaction(
                function(tx){
                    //need to upgared sql query
                    rs = tx.executeSql("SELECT * FROM clube_CusPromoRedeems where user_id='14'");
                }
                )
    return rs;
}

function getSwipe(card_code){
    var db = getDatabase();
    var rs = ""
    db.transaction(
                function(tx){
                    rs = tx.executeSql("SELECT cu.*,cua.* FROM clube_user cu JOIN clube_UserAction cua ON cu.user_id=cua.user_id where cu.card_code='" + card_code + "'");
                    //console.log(rs.rows.item(0).card_code)
                }
                )
    return rs;
}

function getCusProRedeems(card_code){
    var db = getDatabase();
    var rs = "";
    db.transaction(
                function(tx){
                    rs=tx.executeSql("SELECT cpr.*,cp.* FROM clube_CusPromoRedeems cpr JOIN clube_promotion cp ON cpr.promotion_id=cp.promotion_id where cpr.user_id=(SELECT user_id FROM clube_user where card_code='" + card_code + "') AND cpr.flag=0")
                    //console.log(rs.rows.item(0).promo_name);
                }

                )
    return rs;
}

function updateCusPromoRedeem(card,cusPromo_id,flag){
    var db = getDatabase();
    var rs = 0;
    db.transaction(
                function(tx){
                    rs = tx.executeSql("UPDATE clube_CusPromoRedeems SET flag='" + flag + "' WHERE user_id=(SELECT user_id FROM clube_user where card_code='" + card + "') AND cus_promo_redeems_id='" + cusPromo_id + "'");
                }

                )
    return rs.rowsAffected;
}

function addCashPoints(card,amount){
    var db = getDatabase();
    var rs = 0;
    var rs1 = "";
    db.transaction(
                function(tx){
                    rs1=tx.executeSql("SELECT user_id FROM clube_user where card_code='" + card + "'")
                    rs=tx.executeSql('INSERT INTO clube_CusCashPoints (user_id,amount) VALUES(?, ?)', [rs1.rows.item(0).user_id, amount]);
                    //rs1 = tx.executeSql("SELECT * FROM clube_CusCashPoints WHERE CCP_ID='" + rs.insertId + "'");
                    //console.log(rs1.rows.item(0).flag);
                }

                )
    return rs.rowsAffected;
}

function getChangedCusProRedeems(){
    var db = getDatabase();
    var rs = "";
    db.transaction(
                function(tx){
                    rs=tx.executeSql("SELECT cpr.*,cu.* FROM clube_CusPromoRedeems cpr JOIN clube_user cu on cpr.user_id=cu.user_id where cpr.flag=1")
                    //console.log(rs.rows.item(0).card_code);
                }

                )
    return rs;
}

function getCashPoints(){
    //console.log('************************');
    var db = getDatabase();
    var rs = "";
    db.transaction(
                function(tx){
                    rs=tx.executeSql("SELECT ccp.*,cu.* FROM clube_CusCashPoints ccp JOIN clube_user cu on ccp.user_id=cu.user_id where ccp.flag=0")
                    //rs=tx.executeSql("SELECT * FROM clube_user")
                    //console.log('************************');
                    //console.log(rs.rows.length);
                }

                )
    return rs;
}

function test(){
    console.log('working ....')
}
