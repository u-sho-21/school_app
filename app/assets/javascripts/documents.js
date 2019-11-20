var flg = 1;
$(function(){
   // 自身のページを履歴に追加
   history.pushState(null, null, null);
   // ページ戻り時にも自身のページを履歴に追加
   $(window).on("popstate", function(){
       history.pushState(null, null, null);
   });
     $(window).on("beforeunload",function(e){
   if(flg) return "本当に離れますか？";
 });
$('#form_id').submit(function(){
 flg = 0;
});

});