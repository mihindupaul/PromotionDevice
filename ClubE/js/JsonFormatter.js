Qt.include("Storage.js")

function localAuthenticateUser(card_code){
    try{
        var rs = getSwipe(card_code);
        var rs1 = getCusProRedeems(card_code);
        var SWIPE = {
            status : parseInt(rs.rows.item(0).status),
            ispinRequired : parseInt(rs.rows.item(0).ispinRequired),
            eventId : rs.rows.item(0).eventId,
            cashToPointRatio : rs.rows.item(0).cashToPointRatio,
            data : {
                Users : {
                    user_id : rs.rows.item(0).user_id,
                    card_code : rs.rows.item(0).card_code,
                    pin:rs.rows.item(0).pin,
                    CusPromoRedeems: []
                }
            },
            error : {
                code : parseInt(rs.rows.item(0).code),
                message : rs.rows.item(0).message
            }
        };
        console.log(rs1.rows.length);

        for(var i=0;i<rs1.rows.length;i++) {
            SWIPE.data.Users.CusPromoRedeems.push({
                "cus_promo_redeems_id" : rs1.rows.item(i).cus_promo_redeems_id,
                "promotion_id"  : rs1.rows.item(i).promotion_id,
                "promo_name": rs1.rows.item(i).promo_name,
                "promo_description": rs1.rows.item(i).promo_description
            });
        }
        //console.log(JSON.stringify(SWIPE));
        return (JSON.parse(JSON.stringify(SWIPE)));
    }
    catch(err){
        errorDisplay("SORRY (code: JF-auth-ex)","CAN NOT GET LOCAL DATA");
    }
}
