// JavaScript Document

var contentCheckOk;

$(function () {
	
	addWorkNo("tblOrderList","hdnOrderCount");

	Calendar.setup({
        inputField     :    "overTime",   // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,
        timeFormat     :    "24",
		weekNumbers    :	false
		
    });

	var editor;
	KindEditor.ready(function(K) {
	var editor = K.editor({
				uploadJson : '../kindeditor/asp/upload_json.asp',
            	fileManagerJson : '../kindeditor/asp/file_manager_json.asp',
				allowFileManager : true
			});
	$('#formInfo').on('click','.UploadBtn',function() {
				var txtSourceEl=$(this).parent().find(".dfinput_my");
				var txtSourceVal=txtSourceEl.val();
				var lookEl =$(this).prev(".lookHref");
				editor.loadPlugin('image', function() {
					editor.plugin.imageDialog({
						imageUrl : txtSourceVal,
						clickFn : function(url, title, width, height, border, align) {
							lookEl.attr("href",url).css("display","block");
							txtSourceEl.val(url);
							editor.hideDialog();
						}
					});
				});
			});
	
	});
});


function changePhone(){
	var designerPhone=$("#Designer").find("option:selected").attr("dphone");
	$("#designerPhone").val(designerPhone);
}
function checkFormInfo(){
	contentCheckOk =true;
	$("input[type='text']").each(function () {
		if ($(this).val() == "") {
			if($(this).parent().parent().attr("id")!="tblOrderListRow0"){
				$(this).focus();
				//alert($(this).attr("name"));
				alert("您有项目没有填写！");
				contentCheckOk =false;
				return false;
			}
		}
	})			
}
function submitData(){
	if(contentCheckOk)
		$("#formInfo").submit();
}
function submitClick(){
	checkFormInfo();
	submitData();
}
function addWorkNo(tableId,hdnId){
	var el=$("#" + tableId)[0];        
	var rowId=addTableRow(el);
	var hdn = $("#"+hdnId)
	var ids = hdn.val();
	hdn.val(ids + rowId + ",");
	//$("input[id^=txtQJ]").inputer(bs);

}
//删除工单节点
function deleteWorkNo(elemId,tableId,hdnId){
	var index=elemId.replace("btnDeleteWorkNo","");
	var el=$("#" + tableId)[0];
	for(var i=0;i<el.rows.length;i++){
		var objRow=el.rows[tableId + "Row" + index];
		if(el.rows[i]==objRow){
			deleteTableRow(el,i);                
			break;
		}
	}
	var hdn = $("#"+hdnId)
	var ids = hdn.val().replace("," + index + ",",",");
	hdn.val(ids);       
	//$("input[id^=txtQJ]").inputer(bs);
}

 function addTableRow(el){ 
	var objTable = el; 
	var objOldRow=objTable.rows[1];
	//alert(objTable.rows.length-1)                
	var objNewRowId= parseInt(objTable.rows[objTable.rows.length-1].id.replace(el.id+"Row","")) + 1;//最后一行ID
	var objNewRow = objTable.insertRow( objTable.rows.length );        //在Table的末尾新增一行         
	objNewRow.id=el.id + "Row" + objNewRowId; //新行ID
	for(var i=0;i<objOldRow.cells.length;i++){
		var objNewCell = objNewRow.insertCell( i ); 
		var html =  objOldRow.cells[i].innerHTML;
		var reg = /id=.*?[ |>]|name=.*?[ |>]/g;
		var r = html.match(reg); 
		if(r!=null){
			for(var j=0;j<r.length;j++){
				var oldName=r[j];
				var oldTag=r[j].match(/" |">| |>/g)
				var newTag=objNewRowId + oldTag;
				var newName=oldName.replace(oldTag,newTag);                    
				html=html.replace(oldName,newName);             
			}
		}
		objNewCell.innerHTML = html;    //alert(objNewCell.innerHTML); 
	}
	
	return objNewRowId;
}
function deleteTableRow(el,index,minRow){
	var objTable = el;
	if(index==null) index=objTable.rows.length-1;
	if(minRow==null) minRow=2;	    
	if ( objTable.rows.length >minRow ){ 
		objTable.deleteRow(index); 
	} 
}