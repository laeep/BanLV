// JavaScript Document
$(function(){
		$('#xieyi').click(function(){
			if(this.checked){
				$('#regBtn').removeClass('bg80').attr('disabled',false);
			}else{
				$('#regBtn').addClass('bg80').attr('disabled',true);
			}
		});
		
		
		if($('#xieyi').is(':checked')) {
    		$('#regBtn').removeClass('bg80').attr('disabled',false);
		}
		
	});
function register(){
	var account=$("#userName").val();
	//alert(account);
	var password=$("#userPass1").val();
	var password1=$("#userPass2").val();
	var reccode = $("#recCode").val();
	
	if(account==''){
		alert('请输入您要注册的账号');
		return false;
	}
	if(account.length<6 || account.length>20){
		alert('账号长度不符！');
		return false;
	}
	if(password=='' || password1==''){
		alert('密码和重复密码必须输入');
		return false;
	}
	if(password!=password1){
		alert('密码和重复密码不一致');
		return false;
	}
	if(reccode==''){
		alert('请输入您的推荐码');
		return false;
	}
	$("#formReg").submit();
}
function login(){
	var account=$("#account").val();
	var password=$("#password").val();
	var yzCode=$("#yzCode").val();
	if(account==''){
		alert('请输入您的登录账号');
		return false;
	}
	if(account.length<6 || account.length>16){
		alert('登录账号长度不符！');
		return false;
	}
	if(password==''){
		alert('登录密码必须输入');
		return false;
	}
	if(yzCode==''){
		alert('验证码必须输入！');
		return false;
	}
	$("#loginForm").submit();
}