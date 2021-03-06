<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/basejs.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${staticPath}/static/style/css/search.css"/>

<meta http-equiv="X-UA-Compatible" content="edge" />
<title>角色信息管理</title>
<script type="text/javascript">
    var dataGrid;
    $(function() {
        dataGrid = $('#dataGrid').datagrid({
            url : '${path}/pages/role/dataGrid',
            striped : true,
            rownumbers : true,
            pagination : true,
            singleSelect : true,
            idField : 'id',
            sortName : 'a.inserttime',
            sortOrder : 'desc',
            fit : true,
            fitColumns : true,
            fix : false,
            autoRowHeight : false,
            onDblClickRow: function(index,field){
            	$(this).datagrid('beginEdit', index);  
                var ed = $(this).datagrid('getEditor', {index:index,field:field});  
                
                //$("a[data-row='edit_"+index+"']").attr("disabled",'disabled'); 
                $("a[data-row='revoke_"+index+"']").removeAttr("hidden");
                $("a[data-row='save_"+index+"']").removeAttr("hidden");
                $("a[data-row='save_"+index+"']").linkbutton({text:'保存',plain:true,iconCls:'icon-save'});
                $("a[data-row='revoke_"+index+"']").linkbutton({text:'撤销更改',plain:true,iconCls:'icon-undo'});
                
                $("a[data-row='edit_"+index+"']").linkbutton({text:'编辑',plain:true,iconCls:'icon-edit',disabled:true});
                $("a[data-row='del_"+index+"']").linkbutton({text:'删除',plain:true,iconCls:'icon-del',disabled:true});
                $("a[data-row='account_"+index+"']").linkbutton({text:'账户',plain:true,iconCls:'icon-list',disabled:true});
                $("a[data-row='resource_"+index+"']").linkbutton({text:'资源',plain:true,iconCls:'icon-list',disabled:true});
                $("a[data-row='function_"+index+"']").linkbutton({text:'功能',plain:true,iconCls:'icon-list',disabled:true});
            },
            pageSize : 20,
            pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
            columns: [[
			{
                width : '10%',
                title : '主键',
                field : 'id',
                sortable : true,
                align : 'center',
            	hidden : true
            } , 
			{
                width : '10%',
                title : '角色名称',
                field : 'name',
                sortable : false,
                align : 'center',
                editor:{type:'textbox',options:{required:true}},
                hidden : false
            } , 
			{
                width : '10%',
                title : '所属系统',
                field : 'systemName',
                sortable : false,
                align : 'center',
                hidden : false,
                editor:{
                    type: 'combobox',  
                    options: { 
                    	url: '${path}/pages/system/getList', 
	                    valueField: "id",  
	                    textField: "name",  
	                    editable: false,  
	                    panelHeight:70,  
	                    required: true  
                   }  
                }
            } , 
			{
                width : '10%',
                title : '角色状态',
                field : 'status',
                sortable : false,
                align : 'center',
                hidden : false,
                editor:{
                    type: 'combobox',  
                    options: { 
                       data: [{"value":"1","text":"在用"},{"value":"2","text":"停用"}],  
                       valueField: "value",  
                       textField: "text",  
                       editable: false,  
                       panelHeight:70,  
                       required: true  
                   }
                },
                formatter : function(value, row, index) {
                	if(value==1||value==2){
         				switch (value) {
			             case 1:
			                 return '在用';
			             case 2:
			                 return '停用';
			        	}
         			}else{
         				return value;
         			}
         		}
            } , 
            {
                field : 'action',
                title : '操作',
                width : 200,
                align : 'center',
                formatter : function(value, row, index) {
                    var str = '';
	                    str += $.formatString('<a hidden href="javascript:void(0)" class="texpjourPurchInvoiceDet-easyui-linkbutton-save" data-row="save_{0}" data-options="plain:true,iconCls:\'icon-edit\'" onclick="saveRow(\'{1}\',\'{2}\');" >保存</a>', index, row.id, index);
		            	str += $.formatString('<a hidden href="javascript:void(0)" data-row="revoke_{0}" class="texpjourPurchInvoiceDet-easyui-linkbutton-revoke" data-row="revoke_{0}" data-options="plain:true,iconCls:\'icon-edit\'" onclick="revoke(\'{1}\',\'{2}\');" >撤销更改</a>', index, row.id, index);
						str += $.formatString('<a href="javascript:void(0)" data-row="edit_{0}" class="roleList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" >编辑</a>',index);//, row.id
//						str += $.formatString('<a href="javascript:void(0)" class="roleList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
						str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
						if(row.name !="webgate"){
							str += $.formatString('<a href="javascript:void(0)" data-row="del_{0}" class="roleList-easyui-linkbutton-del" data-options="plain:true,iconCls:\'icon-del\'" onclick="deleteFun(\'{1}\',\'{2}\');" >删除</a>',index, row.id,index);
							str += '&nbsp;&nbsp;|&nbsp;&nbsp;';	
						}
						str += $.formatString('<a href="javascript:void(0)" data-row="account_{0}" class="roleList-easyui-linkbutton-final" data-options="plain:true,iconCls:\'icon-list\'" onclick="detailListViewAccount(\'{1}\',\'{2}\');" >赋予账户角色</a>',index, row.id,index);
						str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
						str += $.formatString('<a href="javascript:void(0)" data-row="resource_{0}"class="roleList-easyui-linkbutton-view" data-options="plain:true,iconCls:\'icon-list\'" onclick="detailListViewResource(\'{1}\',\'{2}\');" >关联资源</a>',index, row.id,index);
						str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
						str += $.formatString('<a href="javascript:void(0)" data-row="function_{0}"class="roleList-easyui-linkbutton-fun" data-options="plain:true,iconCls:\'icon-list\'" onclick="detailListViewFunction(\'{1}\',\'{2}\');" >关联功能</a>',index, row.id,index);
					return str;
                }
            } 
			]],
            onLoadSuccess:function(data){
                $('.roleList-easyui-linkbutton-edit').linkbutton({text:'双击编辑',plain:true,iconCls:'icon-edit'});
                for(var num = 0;num<data.rows.length;num++){
                	if(data.rows[num].id!=""){
                		$("a[data-row='del_"+num+"']").linkbutton({text:'删除',plain:true,iconCls:'icon-del'});
                		$("a[data-row='account_"+num+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list'});
                		$("a[data-row='resource_"+num+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list'});
                		$("a[data-row='function_"+num+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list'});
                    }else{
                    	$("a[data-row='del_"+num+"']").linkbutton({text:'删除未保存记录',plain:true,iconCls:'icon-remove'});
                    	$("a[data-row='account_"+num+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list',disabled:true});
                		$("a[data-row='resource_"+num+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list',disabled:true});
                		$("a[data-row='function_"+num+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list',disabled:true});
                    }
                }
            },
            toolbar : '#toolbar'
        });
    });

    function addFun() {
    	var url="${path}/pages/role/addPage";
        openEditDialog(url, 500, 700, dataGrid, function(cid) {
			add(cid);
		}).dialog('open').dialog('setTitle', '新增');
    }

    function editFun(id) {
        if (id == undefined) {
            var rows = dataGrid.datagrid('getSelections');
            id = rows[0].id;
        } else {
            dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
        }                
        var url="${path}/pages/role/editPage?roleId=" + id;
		openEditDialog(url, 500, 700, dataGrid, function(cid) {
			modify(cid);
		}).dialog('open').dialog('setTitle', '修改');
    }

    function deleteFun(id,index) {
        if (id ==""||id == undefined) {
        	$('#dataGrid').datagrid('deleteRow', index);
        	$('#dataGrid').datagrid('acceptChanges');
       		var rows = $('#dataGrid').datagrid("getRows");
       		$('#dataGrid').datagrid("loadData", rows);
        } else {
        	$.messager.confirm('询问', '您是否要删除当前角色信息？', function(b) {
                if (b) {
                    progressLoad();
                    $.post('${path}/pages/role/delete', {
                        id : id
                    }, function(result) {
                        if (result.success) {
                        	easyui_alert(result.msg);
                            dataGrid.datagrid('reload');
                        }else{
                        	easyui_alert(result.msg);
                        }
                        progressClose();
                    }, 'JSON');
                }
            });
        }
        
    }
    
    function searchFun() {
        dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
    }
    
    function cleanFun() {
        $('#searchForm input').val('');
        $('#searchForm select').combobox({
        	onLoadSuccess: function (row, data) {
        		$(this).combobox('setValue', '');
        	}
        });
        dataGrid.datagrid('load', {});
    }
    
    function detailListViewAccount(id) {

    	$('#ListLay').layout('remove','south');
    	$('#ListLay').layout('add',{    
    	    region: 'south',    
    	    width: '100%',
    	    height:'60%',
    	    href:'${path}/pages/account/accountListManagerByRoleId?roleId='+id,
    	    title: '当前角色关联账户信息',    
    	    split: true
    	}); 
    }
    
    function detailListViewResource(id) {

    	$('#ListLay').layout('remove','south');
    	$('#ListLay').layout('add',{    
    	    region: 'south',    
    	    width: '100%',
    	    height:'60%',
    	    href:'${path}/pages/resource/resourceListManagerByRoleId?roleId='+id,
    	    title: '当前角色关联资源信息',    
    	    split: true
    	}); 
    }
    
    
    function detailListViewFunction(id) {
    	$('#ListLay').layout('remove','south');
    	$('#ListLay').layout('add',{    
    	    region: 'south',    
    	    width: '100%',
    	    height:'60%',
    	    href:'${path}/pages/function/functionListManagerByRoleId?roleId='+id,
    	    title: '当前角色关联功能信息',    
    	    split: true
    	}); 
    }
    
</script>
</head>
<body>	
   <div id="ListLay" class="easyui-layout" data-options="fit:true,border:true">
     <div data-options="region:'north',border:false,title:'查询条件'" style="height:70px; overflow: hidden;background-color: #fff">
	    		<form id="searchForm">
	    			<div class="search_condition">
    					<p>
							<b>角色名称：</b>
	                		<input id="name_query" name="name" type="text" placeholder="请输角色名称" class="easyui-validatebox span2" maxlength="32" value=""/>
						</p>
    					<p>
							<b>所属系统：</b>
	                		<select id="systemId_query" name="systemId" class="easyui-combobox" data-options="width:120,height:26,editable:false,panelHeight:'140px'">
			              		<option value="">-请选择-</option>
				                <c:forEach items="${systemList}" var="system">
									<option value="${system.id}">${system.name}</option>
								</c:forEach>
							 </select>
						</p>
						<p>
							<b>角色状态：</b>
	                		<select id="status_query" name="status" class="easyui-combobox" data-options="width:120,height:26,editable:false,panelHeight:'140px'">
			              		<option value="">-请选择-</option>
				                <option value="1">在用</option>
				                <option value="2">停用</option>
							 </select>
						</p>
	    				<p class="btnSear">
			                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a>
			                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="cleanFun();">清空</a>
		                </p>  
	    			</div>
	    		</form>
    		</div>
        <div data-options="region:'center',border:false">
            <table id="dataGrid" data-options="fit:true,border:false"></table>
        </div>
    </div>
    <div id="toolbar" style="display: none;">
    	<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
    	<a onclick="addRow();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加一行</a>
        <a onclick="saveAll();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">保存全部</a>
    </div>
</body>
<script type="text/javascript">
	//如果 操作编辑 则 撤销更改  or 如果 操作新增行，则 删除当前行 
	function revoke(id,index) {
		if(id==""){
			$('#dataGrid').datagrid('cancelEdit', index);
	    	$("a[data-row='edit_"+index+"']").linkbutton({text:'双击编辑',plain:true,iconCls:'icon-edit'});
	    	$("a[data-row='del_"+index+"']").linkbutton({text:'删除未保存记录',plain:true,iconCls:'icon-remove'});
	    	$("a[data-row='account_"+index+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list',disabled:true});
	    	$("a[data-row='resource_"+index+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list',disabled:true});
	    	$("a[data-row='function_"+index+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list',disabled:true});
	    	return;
			$('#dataGrid').datagrid('deleteRow', index);
			var rows = $('#dataGrid').datagrid("getRows");
			$('#dataGrid').datagrid("loadData", rows);
		}else{
			$('#dataGrid').datagrid('cancelEdit', index);
			$("a[data-row='edit_"+index+"']").linkbutton({text:'双击编辑',plain:true,iconCls:'icon-edit'});
	    	$("a[data-row='del_"+index+"']").linkbutton({text:'删除',plain:true,iconCls:'icon-del'});
	    	$("a[data-row='account_"+index+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list'});
	    	$("a[data-row='resource_"+index+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list'});
	    	$("a[data-row='function_"+index+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list'});
		}
	}
	
	function addRow(row){
		if(row===undefined){
			//当前 dataGrid 末尾 增加一行空数据，
	    	$('#dataGrid').datagrid('appendRow',{id:""});
		}else{
			$('#dataGrid').datagrid('appendRow',row);
		}
		//设置 新增行为 编辑状态。
		var rowNumber = $('#dataGrid').datagrid('getData').rows.length-1;
		$('#dataGrid').datagrid('beginEdit', rowNumber);
		
		//显示按钮
		$("a[data-row='revoke_"+rowNumber+"']").removeAttr("hidden");
	    $("a[data-row='save_"+rowNumber+"']").removeAttr("hidden");
	    $("a[data-row='save_"+rowNumber+"']").linkbutton({text:'保存',plain:true,iconCls:'icon-save'});
	    $("a[data-row='revoke_"+rowNumber+"']").linkbutton({text:'撤销更改',plain:true,iconCls:'icon-undo'});
	    $("a[data-row='edit_"+rowNumber+"']").linkbutton({text:'编辑',plain:true,iconCls:'icon-edit',disabled:true});
	    $("a[data-row='del_"+rowNumber+"']").linkbutton({text:'删除',plain:true,iconCls:'icon-del',disabled:true});
	    $("a[data-row='account_"+rowNumber+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list',disabled:true});
    	$("a[data-row='resource_"+rowNumber+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list',disabled:true});
    	$("a[data-row='function_"+rowNumber+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list',disabled:true});
	}
	
	//保存当前行数据
	function saveRow(id,rowIndex){
		$('#dataGrid').datagrid('endEdit', rowIndex);  
		var arr=$('#dataGrid').datagrid('getData');
		var id = arr.rows[rowIndex].id;
		var name=arr.rows[rowIndex].name;
		var systemId=arr.rows[rowIndex].systemName;
		var status=arr.rows[rowIndex].status;
		
		//验证必填
		var validate = $('#dataGrid').datagrid('validateRow', rowIndex);  
		if(!validate){
			easyui_error("请 填写所有必填数据 后进行保存操作");
			return;
		}else{
			if(id=""){
				easyui_alert("组件所属系统不允许更改，点击确定继续操作。");
			}
		}
		//提交编辑当前行
		
		
		saveOne(id,name,systemId,status);
		
		var statusName = '';
		if(status==1){
			statusName ='在用';
		}else if(status == 2){
			statusName ='停用';
		}
		$.ajax({
	        type : "post",  
	    	url : "${path}/pages/system/getList",  
	        async : false,  
	        dataType: "json", 
	        success : function(data){  
	    	    for(var system of data){
			  		if(system.id == systemId){
			  			if(id==""||id==undefined){
			  				$('#dataGrid').datagrid('updateRow',{
				    			index: rowIndex,
				    			row: {
				    				status:statusName,
				    				systemName:system.name
				    			}
				    		});
			  			}else{
			  				$('#dataGrid').datagrid('updateRow',{
				    			index: rowIndex,
				    			row: {
				    				status:statusName,
				    				systemName:"<b style=\"color: red;\">组件所属系统不允许更改，刷新后回复</b>"
				    			}
				    		});
			  			}
			  		}
	  			}
	        }
	     });
			    		
		 $("a[data-row='edit_"+rowIndex+"']").linkbutton({text:'双击编辑',plain:true,iconCls:'icon-edit'});
	     $("a[data-row='del_"+rowIndex+"']").linkbutton({text:'删除',plain:true,iconCls:'icon-del'});
	     $("a[data-row='account_"+rowIndex+"']").linkbutton({text:'赋予账户',plain:true,iconCls:'icon-list',disabled:true});
	     $("a[data-row='resource_"+rowIndex+"']").linkbutton({text:'关联资源',plain:true,iconCls:'icon-list',disabled:true});
	     $("a[data-row='function_"+rowIndex+"']").linkbutton({text:'关联功能',plain:true,iconCls:'icon-list',disabled:true});
	}
	
	//保存 一条记录
    function saveOne(id,name,systemId,status){
    	//id为空，是新增，否则是修改。
    	if(id==''){
			var url ='${path}/pages/role/add';
			var data = {'name':name,'systemId':systemId,'status':status};
		}else{
			var url ='${path}/pages/role/edit';
			var data = {'id':id,'name':name,'systemId':systemId,'status':status};
		}
    	if(name!=""&&systemId!=""&&status!=""&&
    			 name!=undefined && systemId!=undefined && status!=undefined){
    		$.ajax({ 
                url : url,            
                type: "POST",  
                async: false,  
                data: data,            
                dataType: "json",              
                cache: false,  
                success : function(result) {
                    if (result.success) {  
                    	console.log(result);
                    } else {
                    	easyui_error(result.msg);
                    }
                }
            });
    	}
    }
	
  	//保存全部的方法
    function saveAll(){
    	//循环获取当前表格所有数据
    	var arrAll = $('#dataGrid').datagrid('getData');
    	for(var a = 0;a<arrAll.rows.length ;a++){
    		//所有表格结束编辑
    		$('#dataGrid').datagrid('endEdit', a);
    		//所有表格验证必填
    		var validate = $('#dataGrid').datagrid('validateRow', a);  
        	if(!validate){
        		easyui_error("请 填写所有必填数据 后进行保存操作");
        		return;
        	}
    	}
    	//获取所有编辑过的数据
    	var arr=dataGrid.datagrid('getChanges');
    	//循环保存所有数据
    	for (var index = 0; index < arr.length; index++) {
    		var id = arr[index].id;
    		var name = arr[index].name;
    		var status = arr[index].status;
    		var systemId = arr[index].systemName;
    		
    		saveOne(id,name,systemId,status);
    	}
    	//重新加载 dataGrid
    	dataGrid.datagrid('load', {});
    }
</script>
</html>