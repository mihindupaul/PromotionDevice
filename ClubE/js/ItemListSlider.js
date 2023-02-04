//Qt.include("APICaller.js")

//var PAGE_COUNT=1;
//var MODEL_POINTER=3;

//function loadNextItems(){
//    try
//    {
//        initItemsText();
//        //MODEL_POINTER=((PAGE_COUNT*4) - 1) -4
//        rec1_txt.text=itemModel.get(MODEL_POINTER + 1).dec1 + "\n" + itemModel.get(MODEL_POINTER + 1).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER + 1).cost + "/=";
//        MODEL_POINTER+=1
//        rec2_txt.text=itemModel.get(MODEL_POINTER + 1).dec1 + "\n" + itemModel.get(MODEL_POINTER + 1).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER + 1).cost + "/=";
//        MODEL_POINTER+=1
//        rec3_txt.text=itemModel.get(MODEL_POINTER + 1).dec1 + "\n" + itemModel.get(MODEL_POINTER + 1).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER + 1).cost + "/=";
//        MODEL_POINTER+=1
//        rec4_txt.text=itemModel.get(MODEL_POINTER + 1).dec1 + "\n" + itemModel.get(MODEL_POINTER + 1).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER + 1).cost + "/=";
//        MODEL_POINTER+=1
//     }
//    catch(err) {
//        console.log('exception from ItemListSlider.js/loadNextItems')
//    }
//}

//function loadBackItems(){
//    initItemsText();
//    MODEL_POINTER=(PAGE_COUNT*4) - 1
//    rec1_txt.text=itemModel.get(MODEL_POINTER - 3).dec1 + "\n" + itemModel.get(MODEL_POINTER - 3).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER - 3).cost + "/=";
//    rec2_txt.text=itemModel.get(MODEL_POINTER - 2).dec1 + "\n" + itemModel.get(MODEL_POINTER - 2).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER - 2).cost + "/=";
//    rec3_txt.text=itemModel.get(MODEL_POINTER - 1).dec1 + "\n" + itemModel.get(MODEL_POINTER - 1).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER - 1).cost + "/=";
//    rec4_txt.text=itemModel.get(MODEL_POINTER).dec1 + "\n" + itemModel.get(MODEL_POINTER).dec2 + "\n" + "RS " + itemModel.get(MODEL_POINTER).cost + "/=";
//    //MODEL_POINTER-=4
//    //console.log(MODEL_POINTER)
//}

function onClickNextBtn(){
    console.log(PAGE_COUNT)
    if ((PAGE_COUNT+1) <= PAGE_COUNT){
        page_num_txt.text=++PAGE_COUNT + "/" + PAGE_COUNT;
        //loadNextItems();
    }
}

function onClickBackBtn(){
    if (PAGE_COUNT > 1){
        page_num_txt.text=--PAGE_COUNT + "/" + Math.ceil(itemModel.count/4)
        //loadBackItems();
    }
}

function initItemsText(){
    rec1_txt.text="no data available";
    rec2_txt.text="no data available";
    rec3_txt.text="no data available";
    rec4_txt.text="no data available";
}
