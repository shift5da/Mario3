

function change_tab_active(tab_id){
  $("a[class|='weui-tabbar__item']").each(function functionName() {
    $(this).removeClass();
    if (this.id == tab_id){
      $(this).attr('class', 'weui-tabbar__item weui-bar__item_on');
    }else{
      $(this).attr('class', 'weui-tabbar__item');
    }
  });
}
