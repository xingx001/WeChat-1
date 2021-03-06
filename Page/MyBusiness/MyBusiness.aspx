﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyBusiness.aspx.cs" Inherits="WeChat.Page.MyBusiness.MyBusiness" %>

<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>我的订单</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1, maximum-scale=1" />
    <link href="/css/iconfont/iconfont.css?t=<%=ConfigurationManager.AppSettings["Version"]%>" rel="stylesheet" />
    <link rel="stylesheet" href="//g.alicdn.com/msui/sm/0.6.2/css/sm.min.css" />
    <script type='text/javascript' src='//g.alicdn.com/sj/lib/zepto/zepto.min.js' charset='utf-8'></script>
    <link rel="stylesheet" href="//g.alicdn.com/msui/sm/0.6.2/css/sm-extend.min.css" />
    <link rel="stylesheet" href="/css/extraSearch.css?t=<%=ConfigurationManager.AppSettings["Version"]%>" />
    <script type="text/javascript" src="/js/extraSearch.js?t=<%=ConfigurationManager.AppSettings["Version"]%>"></script>
    <script type="text/javascript" src="/js/SubscribeInfo.js?t=<%=ConfigurationManager.AppSettings["Version"]%>"></script>
    <script type="text/javascript" src="/js/BusiInfoDetail.js?t=<%=ConfigurationManager.AppSettings["Version"]%>"></script>
    <style type="text/css">
        #scroll-bottom-one {
            top: 5.8rem;
        }

        .bar input[type=search] {
            margin: .1rem 0;
        }

        .bar-nav {
            height: 5.8rem;
        }

        .content-padded {
            margin: 0.2rem;
        }

        .list-block {
            margin: 0.2rem 0 0 0;
        }

            .list-block .item-inner {
                padding-right: 0.25rem;
                padding-top: 0.1rem;
                padding-bottom: 0.1rem;
                min-height: 1.2rem;
                font-size: small;
            }

            .list-block .item-content {
                min-height: 1.2rem;
            }

            .list-block .my-title {
                width: 40%;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
                text-align: center;
            }

            .list-block .my-after {
                width: 30%;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
                text-align: center;
            }

        .picker-items-col-wrapper {
            width: 12rem;
        }

        .popup-subscribe .content-block {
            background-color: #1D2E3C;
            color: white;
            margin-top: 1rem;
        }

        .popup-subscribe .row {
            background-color: #456581;
            border-top: solid 1px white;
            margin: 0rem;
            font-size: initial;
            vertical-align: middle;
            height: 2rem;
            line-height: 2rem;
        }

        .popup-subscribe .col-33 {
            padding-top: 0.2rem;
        }

        .popup-subscribe .col-50 {
            margin-left: 2%;
        }

        .myrow {
            line-height: 2rem;
            padding-left: 4%;
        }

        .girdnamediv {
            width: 17.6rem;
            margin-left: -8.75rem;
            top: 14%;
        }

        /*----------------------------*/
        #page-infinite-scroll-bottom .search-input input {
            border-radius: 0;
            font-size: 13px;
        }

        #popup-subscribe-log input {
            font-family: "微软雅黑";
            width: 6rem;
            height: 1.5rem;
            border: none;
            border-radius: .15rem;
            font-size: .8rem;
        }

        #popup-subscribe-decl input {
            font-family: "微软雅黑";
            width: 6rem;
            height: 1.5rem;
            border: none;
            border-radius: .15rem;
            font-size: .8rem;
        }
        /*----------------------------------------*/
        .picdiv .modal-inner {
            padding: 0;
        }

        .picdiv .modal-title {
            text-align: right;
        }

            .picdiv .modal-title + .modal-text {
                margin-top: 0;
            }
        .float-button {
            position: fixed;
            bottom: 120px;
            right: 0px;
            z-index: 300;
        }
    </style>

    <script type="text/javascript">
        // 加载flag
        var loading = false;
        // 最多可加载的条目
        var maxItems = 100;
        // 每次加载添加多少条目
        var itemsPerLoad = 6;
        var lastIndex = 0;
        var subOrderCode="", subCusno = "", subDeclarationCode = "";//订阅的单号
        //按钮查询
        function loadData(itemsPerLoad, lastIndex) {
            $.ajax({
                type: "post", //要用post方式                 
                //url: "MyBusiness.aspx?action=QueryData",//进入load根据action匹配方法
                url: "MyBusiness.aspx/QueryData",//通过static+[webmethod],直接访问指定的方法
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{'submittimestart':'" + $("#txt_submittime_s").val() +
                        "','submittimeend':'" + $("#txt_submittime_e").val() +
                        "','declarationcode':'" + $("#txt_declcode").val() +
                        "','customarea':'" + $("#txt_customareacode").val() +
                        "','ispass':'" + $("#picker_is_pass").val() +
                        "','ischeck':'" + $("#picker_ischeck").val() +
                        "','busitype':\"" + $("#txt_busitype").val() +
                        "\",'modifyflag':'" + $("#txt_modifyflag").val() +
                        "','auditflag':'" + $("#txt_auditflag").val() +
                        "','busiunit':'" + $("#txt_busiunit").val() +
                        "','ordercode':'" + $("#txt_ordercode").val() +
                        "','cusno':'" + $("#txt_cusno").val() +
                        "','divideno':'" + $("#txt_divideno").val() +
                        "','contractno':'" + $("#txt_contractno").val() +
                        "','passtimestart':'" + $("#txt_sitepasstime_s").val() +
                        "','passtimeend':'" + $("#txt_sitepasstime_e").val() +
                        "','itemsperload':" + itemsPerLoad +
                        ",'lastindex':" + lastIndex + "}",
                cache: false,
                async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                success: function (data) {
                    if (data.d == null || data.d == "" || data.d == "[]") {
                        $("#span_sum").text(0);
                        $("#busicontent").append("");
                        return;
                    }
                    var obj = eval("(" + data.d + ")");//将字符串转为json
                    $("#span_sum").text(obj[0]["SUM"]);
                    for (var i = 0; i < obj.length; i++) {
                        var str = '<div class="list-block" id="' + obj[i]["CODE"] + ',' + obj[i]["CUSNO"] + '" >' +
                                    '<ul>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">' + (obj[i]["BUSIUNITNAME"] == null ? "" : obj[i]["BUSIUNITNAME"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["BUSITYPENAME"] == null ? "" : obj[i]["BUSITYPENAME"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["CUSNO"] == null ? "" : obj[i]["CUSNO"]) + '</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">' + (obj[i]["DIVIDENO"] == null ? "" : obj[i]["DIVIDENO"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["REPWAYNAME"] == null ? "" : obj[i]["REPWAYNAME"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["CONTRACTNO"] == null ? "" : obj[i]["CONTRACTNO"]) + '</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">' + (obj[i]["GOODSNUM"] == null ? "" : obj[i]["GOODSNUM"]) + '/' + obj[i]["GOODSGW"] + '</div>' +
                                                '<div class="my-after">' + (obj[i]["ISCHECK"] == null ? "" : obj[i]["ISCHECK"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["CHECKPIC"] == null ? "" : obj[i]["CHECKPIC"]) + '</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">' + (obj[i]["DECLSTATUS"] == null ? "" : obj[i]["DECLSTATUS"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["INSPISCHECK"] == null ? "" : obj[i]["INSPISCHECK"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["LAWFLAG"] == null ? "" : obj[i]["LAWFLAG"]) + '</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">' + (obj[i]["INSPSTATUS"] == null ? "" : obj[i]["INSPSTATUS"]) + '</div>' +
                                                '<div class="my-after">' + (obj[i]["LOGISTICSNAME"] == null ? "" : obj[i]["LOGISTICSNAME"]) + '</div>' +
                                                '<div class="my-after"></div>' +
                                            '</div>' +
                                        '</li>' +
                                    '</ul>' +
                                  '</div>';
                        $("#busicontent").append(str);
                    }
                }
            });
        }

        //查询
        $(function () {
            $('.infinite-scroll-preloader').hide();
            //初始化查询条件
            initsearch_condition();
            //初始化高级查询
            initSerach_MyOrder();
            //列名
            $("#btn_gridname_m").click(function () {
                showGridName();
            });
            //重置
            $("#btn_reset_m").click(function () {
                $("#txt_submittime_s").val(""); $("#txt_submittime_e").val("");
                $("#txt_submittime_s").calendar({}); $("#txt_submittime_e").calendar({});//否则之前选的那天  不能再次选中

                $("#txt_declcode").val(""); $("#txt_customareacode").val("");
                $("#picker_is_pass").picker("setValue", ["全部"]); $("#picker_ischeck").picker("setValue", ["全部"]);

                $("#txt_busitype").val("");
                $("#txt_modifyflag").val("");
                $("#txt_auditflag").val("");

                $("#txt_busiunit").val("");
                $("#txt_ordercode").val("");
                $("#txt_cusno").val("");
                $("#txt_divideno").val("");
                $("#txt_contractno").val("");
                $("#txt_sitepasstime_s").val("");
                $("#txt_sitepasstime_e").val("");
            });

            //查询
            $(document).on('click', '#btn_search_m', function () {
                $('.infinite-scroll-preloader').hide();

                $("#busicontent").html("");
                $.showPreloader('加载中...');

                setTimeout(function () {
                    $.closeModal();

                    lastIndex = 0;
                    $('.infinite-scroll-preloader').show();
                    $.attachInfiniteScroll($('.infinite-scroll'));

                    loadData(itemsPerLoad, lastIndex); //加载数据
                    lastIndex = $('#busicontent .list-block').length; //获取数据条数
                    $.refreshScroller(); //刷新滚动条
                    $('.infinite-scroll-bottom').scrollTop(0); //滚动条置顶

                    if (lastIndex < itemsPerLoad) {
                        $.detachInfiniteScroll($('.infinite-scroll-bottom')); // 加载完毕，则注销无限加载事件，以防不必要的加载     
                        $('.infinite-scroll-preloader').hide();
                        if (lastIndex == 0) {
                            $.toast("没有符合的数据！");
                        } else {
                            $.toast("已经加载到最后");
                        }
                    }
                    $.hidePreloader();
                }, 500);

            });

            

            //无限滚动 注册'infinite'事件处理函数
            $(document).on('infinite', "#page-infinite-scroll-bottom", function () {

                if (loading) return;// 如果正在加载，则退出               
                loading = true; // 设置flag                
                $('.infinite-scroll-preloader').show();//显示加载栏

                setTimeout(function () { // 模拟1s的加载过程                    
                    loading = false;// 重置加载flag
                    if (lastIndex >= maxItems || lastIndex % itemsPerLoad != 0) {
                        // 加载完毕，则注销无限加载事件，以防不必要的加载
                        $.detachInfiniteScroll($('.infinite-scroll'));
                        // 删除加载提示符
                        $('.infinite-scroll-preloader').hide();
                        $.toast("已经加载到最后");
                        return;
                    }
                    // 添加新条目
                    loadData(itemsPerLoad, lastIndex);

                    if (lastIndex == $('#busicontent .list-block').length) {
                        $.detachInfiniteScroll($('.infinite-scroll')); // 加载完毕，则注销无限加载事件，以防不必要的加载     
                        $('.infinite-scroll-preloader').hide();

                        $.toast("已经加载到最后");
                        return;
                    }
                    // 更新最后加载的序号
                    lastIndex = $('#busicontent .list-block').length;
                    //容器发生改变,如果是js滚动，需要刷新滚动
                    $.refreshScroller();
                }, 500);
            });

            //选中业务变色
            $("#busicontent").on('click',
                '.list-block',
                function (e) { // $("#div_list")也可以换成$(document)，是基于父容器的概念   

                    if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {
                        $(this).children("ul").css('background-color', '#fff');
                    } else {
                        $("#busicontent .list-block ul").css('background-color', '#fff');
                        $(this).children("ul").css('background-color', '#C1DDF1');
                    }
                });


            //功能菜单
            $(document).on('click',
                '.tab-item',
                function (e) {
                    $(".tab-item").removeClass("active");
                    $(this).addClass("active");
                })

            //条码扫描
            $("#btn_barcode").click(function () {
                wx.ready(function () {
                    wx.scanQRCode({
                        needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                        scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                        success: function (res) {
                            var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                            var serial = result.split(",");
                            var serialNumber = serial[serial.length - 1];
                            $("#txt_declcode").val(serialNumber);
                        }
                    });

                });
                //初始化jsapi接口 状态
                wx.error(function (res) {
                    alert("调用微信jsapi返回的状态:" + res.errMsg);
                });
            });
           
            $.init();

        });

        //打开详情弹出框
        $(document).on('click', '.open-detail', function () {
            
            var ordercode = "";
            $("#busicontent .list-block").each(function () {
                if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {
                    var code = $(this)[0].id;
                    ordercode = code.split(",")[0];
                }
            });
            if (ordercode != "") {
                getBusiInfo_company(ordercode);
            }
            else {
                $.toast("请选择需要一条记录");
            }

        });
        //打开业务订阅弹出框
        $(document).on('click', '.open-subscribe', function () {
            var cusno = "", ordercode = "";
            $("#busicontent .list-block").each(function () {

                if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {
                    var code = $(this)[0].id;
                    cusno = code.split(",")[1];
                    ordercode = code.split(",")[0];
                }
            });
            if (cusno == "") {
                $.toast("请选择需要订阅的记录");
                return;
            }
            subCusno = cusno;
            subOrderCode = ordercode;
            $.popup("#popup-subscribe-log");
        });
       
        //订阅消息
        function subscribe(type) {
            var status = "";
            var input;
            if (type == "订单状态") {
                if (subOrderCode == "") {
                    $.toast("请选择需要订阅的业务");
                    return;
                }
                else {
                    var tab = $(".popup-subscribe .tab").css("display");
                    if (tab == "block") {
                        type = "业务状态";
                        input = $("#pop_sub_order input");
                    }
                    else {
                        type = "物流状态";
                        input = $("#pop_sub_log input");
                    }
                }
            }
            if (type == "报关状态") {
                if (subDeclarationCode == "") {
                    $.toast("请选择需要订阅的报关单");
                    return;
                }
                else {
                    input = $("#pop_sub_decl input");
                }
            }
            for (var i = 0; i < input.length; i++) {
                if (input[i].checked) {
                    status += input[i].value + ",";
                }
            }
            if (status == "") {
                $.toast("请选择需要订阅的状态");
                return;
            }
            $.ajax({
                type: 'post',
                url: 'MyBusiness.aspx/SubscribeStatus',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{'type':'" + type +
                    "','status':'" + status +
                    "','cusno':'" + subCusno +
                    "','declarationcode':'" + subDeclarationCode +
                    "','ordercode':'" + subOrderCode +
                    "'}",
                cache: false,
                async: false, //默认是true，异步；false为同步，此方法执行完在执行下面代码
                success: function (data) {
                    $.toast(data.d);
                }
            });
        }

        //返回后Checked置空
        $(document).on('click', '#backto_decl', function () {
            var input = $('.popup input');
            for (var i = 0; i < input.length; i++) {
                if (input[i].checked) {
                    input[i].checked = false;
                }
            }
            $("[href='#sub_tab1']").addClass("active"); $("#sub_tab1").addClass("active");
            $("[href='#sub_tab2']").removeClass("active"); $("#sub_tab2").removeClass("active");
        });
        $(document).on('click', '#backto_log', function () {
            var input = $('.popup input');
            for (var i = 0; i < input.length; i++) {
                if (input[i].checked) {
                    input[i].checked = false;
                }
            }
            $("[href='#sub_tab1']").addClass("active"); $("#sub_tab1").addClass("active");
            $("[href='#sub_tab2']").removeClass("active"); $("#sub_tab2").removeClass("active");
        });
        function showFile() {
            $.modal({
                title: '<i id="picfilecancel" class="iconfont" style="font-size:1.3rem;">&#xea4f;</i>',
                text: '<span style="font-weight:800;">文件调阅</span>' +
                        '<div class="content-block row" style="margin:0;padding:.75rem;">' +
                            '<div class="col-50"><a href="#" id="declpdf" class="button" style="background-color: #3d4145;color:white;border-radius:0;border:0;vertical-align:middle;">报关文件</a></div>' +
                            '<div class="col-50"><a href="#" id="checkpic" class="button" style="background-color: gray;color:white;border-radius:0;border:0;vertical-align:middle;">查验文件</a></div>' +
                        '</div>',

                //title: '文件',
                //text: '<div class="content-block row">' +
                //            '<div class="col-33"><a href="#" id="picfilecancel" class="button">返回</div>' +
                //            '<div class="col-33"><a href="#" id="declpdf" class="button">报关单</div>' +
                //            '<div class="col-33"><a href="#" id="checkpic" class="button">查验文件</a></div>' +
                //        '</div>',
                extraClass: 'picdiv'//避免直接设置.modal的样式，从而影响其他toast的提示
            });
            $("#picfilecancel").click(function () {
                $.closeModal(".picdiv");
            });
            $("#declpdf").click(function () {
                showDeclPdf();
                $.closeModal(".picdiv");
            });
            $("#checkpic").click(function () {
                showCheckPic();
                $.closeModal(".picdiv");
            });
        }
        //报关单调阅
        function showDeclPdf() {
            var ordercode = "";
            $("#busicontent .list-block").each(function () {

                if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {

                    ordercode = $(this)[0].id;
                    ordercode = ordercode.split(",")[0];
                }
            });

            if (ordercode == "") {
                $.toast("请选择需要调阅的记录");
                return;
            }
            $.ajax({
                type: 'post',
                url: 'MyBusiness.aspx/GetDeclPdf',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{'orderCode':'" + ordercode + "'}",
                cache: false,
                async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                success: function (data) {
                    if (data.d == "") {
                        $.toast("报关单文件不存在");
                        return;
                    }

                    var picstr = data.d;
                    var picarr = picstr.split(',');

                    var imgs = "[";
                    for (var i = 0; i < picarr.length; i++) {
                        if (picarr[i] != "") { imgs += "'/TempFile/tempPic/" + picarr[i] + "',"; }
                    }
                    imgs += "]";

                    var myPhotoBrowserStandalone = $.photoBrowser({
                        photos: eval(imgs)
                    });
                    myPhotoBrowserStandalone.open();
                }
            })
        }
        //查验图片调阅
        function showCheckPic() {
            var ordercode = "";
            $("#busicontent .list-block").each(function () {

                if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {
                    ordercode = $(this)[0].id;
                    ordercode = ordercode.split(",")[0];
                }
            });
            if (ordercode == "") {
                $.toast("请选择需要调阅的记录");
                return;
            }

            $.ajax({
                type: "post", //要用post方式                 
                url: "/page/BusiOpera/SiteDeclareList.aspx/picfileconsult",//方法所在页面和方法名
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{'ordercode':'" + ordercode + "'}",
                cache: false,
                async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                success: function (data) {
                    var obj = eval("(" + data.d + ")");//将字符串转为json
                    var imgs = "[";
                    for (var i = 0; i < obj.length; i++) {
                        imgs += "'" + $("#hd_AdminUrl").val() + "file/" + obj[i]["FILENAME"] + "',";
                    }
                    imgs += "]";

                    var myPhotoBrowserStandalone = $.photoBrowser({
                        photos: eval(imgs)
                    });
                    myPhotoBrowserStandalone.open();
                }
            });
        }
        //订阅清单
        function subscribeInfo() {
            window.location.href = "NewSubscribeList_busi.aspx";
        }

        //显示列名
        function showGridName() {
            var strname = '<div class="list-block" >' +
                                    '<ul>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">经营单位</div>' +
                                                '<div class="my-after">业务类型</div>' +
                                                '<div class="my-after">企业编号</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">分单号</div>' +
                                                '<div class="my-after">申报方式</div>' +
                                                '<div class="my-after">合同号</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">件数/毛重</div>' +
                                                '<div class="my-after">报关查验</div>' +
                                                '<div class="my-after">查验图片</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">报关状态</div>' +
                                                '<div class="my-after">报检查验</div>' +
                                                '<div class="my-after">是否法检</div>' +
                                            '</div>' +
                                        '</li>' +
                                        '<li class="item-content">' +
                                            '<div class="item-inner">' +
                                                '<div class="my-title">报检状态</div>' +
                                                '<div class="my-after">物流状态</div>' +
                                                '<div class="my-after"></div>' +
                                            '</div>' +
                                        '</li>' +
                                    '</ul>' +
                                  '</div>';
            $.modal({
                //title: '<b>更多查询</b>',
                text: strname,
                //buttons: [{ text: '取消', bold: true, onClick: function () { } }],
                extraClass: 'girdnamediv'//避免直接设置.modal的样式，从而影响其他toast的提示
            });

            $(document).on('click', '.girdnamediv', function () {
                $.closeModal(".girdnamediv");
            });

        }

        //查询条件初始化
        function initsearch_condition() {
            $("#picker_is_pass").picker({
                toolbarTemplate: '<header class="bar bar-nav">\
                      <button class="button button-link pull-right close-picker">确定</button>\
                      <h1 class="title">请选择放行情况</h1>\
                      </header>',
                cols: [
                  {
                      textAlign: 'center',
                      values: ['全部', '未放行', '已放行']
                  }
                ]
            });

            $("#picker_ischeck").picker({
                toolbarTemplate: '<header class="bar bar-nav">\
                      <button class="button button-link pull-right close-picker">确定</button>\
                      <h1 class="title">请选择查验情况</h1>\
                      </header>',
                cols: [
                  {
                      textAlign: 'center',
                      values: ['全部', '查验', '未查验']
                  }
                ]
            });

            //初始化时间控件
            //var before = new Date();
            //before.setDate(before.getDate() - 3);
            //var beforeday = before.Format("yyyy-MM-dd");

            //var now = new Date();
            //var today = now.Format("yyyy-MM-dd");

            //$("#txt_submittime_s").val(beforeday);
            //$("#txt_submittime_s").calendar({ value: [beforeday] });

            //$("#txt_submittime_e").val(today);
            //$("#txt_submittime_e").calendar({ value: [today] });

            $("#txt_submittime_s").calendar({});
            $("#txt_submittime_e").calendar({});
        }

        //清除选中
        function clearSelect() {
            $("#busicontent .list-block").each(function () {
                if ($(this).children("ul").css('background-color') == "rgb(193, 221, 241)") {
                    $(this).children("ul").css('background-color', '#fff');
                }
            });
        }



        


    </script>
</head>
<body>

    <form id="form1" runat="server">

        <div class="page-group">
            <!-- page1 消息订阅-->
            <div class="page page-current" id="page-infinite-scroll-bottom">

                <header class="bar bar-nav">
                    <%--style="height:5rem;"--%><%--暂时不用，就是查询背景色第二行--%>
                    <div class="search-input">
                        <div class="row">
                            <div class="col-33" style="width: 20%; font-size: 13px; margin-top: .3rem;">委托时间:</div>
                            <div class="col-33" style="width: 28%; margin-left: 0;">
                                <input type="search" id='txt_submittime_s' /></div>
                            <div class="col-33" style="width: 28%; margin-left: 0;">
                                <input type="search" id='txt_submittime_e' /></div>
                            <div class="col-10" style="width: 10%; margin-left: 0; margin-top: .14rem;">
                                <input id="btn_more_m" type="button" value="..." class="open-tabs-modal" style="background-color: #3D4145; color: #ffffff; border-radius: 0; border: 0;" />
                            </div>
                            <div class="col-15" style="width:5%;margin-left:2%;"><a href="#" id="btn_barcode"><i class="iconfont" style="font-size:1.3rem;color:gray;">&#xe608;</i></a></div>
                        </div>
                        <div class="row">
                            <div class="col-50" style="width: 46%;">
                                <input type="search" id='txt_declcode' placeholder='报关单号' /></div>
                            <div class="col-20" style="width: 19%; margin-left: 0;">
                                <input type="search" id='txt_customareacode' placeholder='申报关区' /></div>
                            <div class="col-15" style="width: 15%; margin-left: 0;">
                                <input type="search" id='picker_is_pass' placeholder='放行' /></div>
                            <div class="col-15" style="width: 15%; margin-left: 0;">
                                <input type="search" id='picker_ischeck' placeholder='查验' /></div>
                        </div>
                        <div class="row">
                            <div class="col-25" style="width: 21%;">
                                <input id="btn_gridname_m" type="button" value="列名" style="background-color: #808080; color: #ffffff; border-radius: 0; border: 0;" /></div>
                            <div class="col-60" style="width: 54%; margin-left: 0;">
                                <input id="btn_search_m" type="button" value="查询" style="background-color: #3D4145; color: #ffffff; border-radius: 0; border: 0;" /></div>
                            <div class="col-25" style="width: 21%; margin-left: 0;">
                                <input id="btn_reset_m" type="button" value="重置" style="background-color: #808080; color: #ffffff; border-radius: 0; border: 0;" /></div>
                        </div>
                        <input type="hidden" id='txt_busitype' />
                        <input type="hidden" id='txt_modifyflag' />
                        <input type="hidden" id='txt_auditflag' />
                        <input type="hidden" id='txt_busiunit' />
                        <input type="hidden" id='txt_ordercode' />
                        <input type="hidden" id='txt_cusno' />
                        <input type="hidden" id='txt_divideno' />
                        <input type="hidden" id='txt_contractno' />
                        <input type="hidden" id='txt_sitepasstime_s' />
                        <input type="hidden" id='txt_sitepasstime_e' />
                    </div>
                    <div id="div_tbar" style="font-size: 13px; margin: .2rem 0;">
                        <span style="color: #929292">共计</span>
                        <span id="span_sum">0</span>
                        <span style="color: #929292">笔</span>
                    </div>
                </header>



                <!-- 工具栏 -->
                <nav class="bar bar-tab">
                    
                    <a class="tab-item  open-subscribe" href="#">
                        <span class="icon icon-edit"></span>
                        <span class="tab-label">消息订阅</span>
                    </a>
                    <a class="tab-item open-declpdf" href="javascript:showFile()">
                        <span class="icon icon-star"></span>
                        <span class="tab-label">文件调阅</span>
                    </a>
                    <a class="tab-item open-detail" href="#">
                        <span class="icon icon-menu"></span>
                        <span class="tab-label">业务详情</span>
                    </a>
                    <input type="hidden" id="hd_AdminUrl" value='<%= System.Configuration.ConfigurationManager.AppSettings["AdminUrl"] %>' />
                </nav>



                <!-- 这里是页面内容区 -->
                <div class="content infinite-scroll infinite-scroll-bottom" data-distance="100" id="scroll-bottom-one">
                    <div id="busicontent"></div>
                    <!-- 加载提示符 -->
                    <div class="infinite-scroll-preloader">
                        <div class="preloader"></div>
                    </div>
                    <div class="float-button" onclick="clearSelect()"><img src="../../image/clearbtn.png" /></div>
                </div>
            </div>
        </div>

        <!--popup 详情弹出页-->
        <div class="popup popup-detail">
            <div class="content" style="bottom: 60px;">
                <div class="buttons-tab">
                    <a href="#tab1" class="tab-link active button">报关信息</a>
                    <a href="#tab2" class="tab-link button">报检信息</a>
                    <a href="#tab3" class="tab-link button">物流信息</a>
                </div>
                <div class="content-block">
                    <div class="tabs">
                        <div id="tab1" class="tab active">
                            <div class="content-block " id="pop_tab_decl"></div>
                        </div>
                        <div id="tab2" class="tab">
                            <div class="content-block" id="pop_tab_insp"></div>
                        </div>
                        <div id="tab3" class="tab">
                            <div class="content-block" id="pop_tab_logistics"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="bottom: 1.5rem; position: absolute; width: 80%; margin-left: 10%"><a href="#" class="close-popup button">返&nbsp;&nbsp;&nbsp;&nbsp;回</a></div>
        </div>
        <!--popup 报关订阅弹出页-->
        <div class="popup popup-subscribe" id="popup-subscribe-decl">
            <div class="content">
                <div class="content-block" id="pop_sub_decl">
                    <div class="myrow">报关状态订阅</div>
                    <div class="row">
                        <div class="col-66">申报完成</div>
                        <div class="col-33">
                            <input type="checkbox" value="申报完成" /></div>
                    </div>
                    <div class="row">
                        <div class="col-66">已放行</div>
                        <div class="col-33">
                            <input type="checkbox" value="已放行" /></div>
                    </div>
                    <div class="row">
                        <div class="col-66">已结关</div>
                        <div class="col-33">
                            <input type="checkbox" value="已结关" /></div>
                    </div>
                    <div class="row">
                        <div class="col-66">改单完成</div>
                        <div class="col-33">
                            <input type="checkbox" value="改单完成" /></div>
                    </div>
                    <div class="row">
                        <div class="col-66">删单完成</div>
                        <div class="col-33">
                            <input type="checkbox" value="删单完成" /></div>
                    </div>
                </div>
                <div class="row" style="background-color: white; margin-top: 1rem">
                    <div class="col-50"><a href="#" class="close-popup button" id="backto_decl">返  回</a></div>
                    <div class="col-50"><a href="javascript:subscribe('报关状态')" class="button" style="background-color: #3d4145">确  认</a></div>
                </div>
            </div>
        </div>
        <!--popup 业务订阅弹出页-->
        <div class="popup popup-subscribe" id="popup-subscribe-log">
            <div class="content">
                <div class="buttons-tab">
                    <a href="#sub_tab1" class="tab-link active button">业务状态</a>
                    <a href="#sub_tab2" class="tab-link button">物流状态</a>
                </div>
                <div class="content-block">
                    <div class="tabs">
                        <div id="sub_tab1" class="tab active">
                            <div class="content-block" id="pop_sub_order">
                                <div class="myrow">业务状态订阅</div>
                                <div class="row">
                                    <div class="col-66">订单受理</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="订单受理" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">申报开始</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="申报开始" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">提前申报完成</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="提前申报完成" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">申报完成</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="申报完成" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">现场报关</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="现场报关" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">现场放行</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="现场放行" /></div>
                                </div>
                            </div>
                        </div>
                        <div id="sub_tab2" class="tab">
                            <div class="content-block" id="pop_sub_log">
                                <div class="myrow">物流状态订阅</div>
                                <div class="row">
                                    <div class="col-66">抽单完成</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="抽单完成" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">已派车</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="已派车" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">运输完成</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="运输完成" /></div>
                                </div>
                                <div class="row">
                                    <div class="col-66">送货完成</div>
                                    <div class="col-33">
                                        <input type="checkbox" value="送货完成" /></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" style="background-color: white; margin-top: 1rem">
                    <div class="col-50"><a href="#" class="close-popup button" id="backto_log">返  回</a></div>
                    <div class="col-50"><a href="javascript:subscribe('订单状态')" class="button" style="background-color: #3d4145">确  认</a></div>
                </div>
            </div>
        </div>
        <!--popup 订阅详情弹出页-->
        <div class="popup pop-subscribeinfo">
            <div class="content" id="subscribeinfo" style="bottom: 3rem;">
            </div>
            <div style="bottom: 1.5rem; position: fixed; width: 80%; margin-left: 10%"><a href="#" class="close-popup button">返&nbsp;&nbsp;&nbsp;&nbsp;回</a></div>
        </div>

        <!-- 默认必须要执行$.init(),实际业务里一般不会在HTML文档里执行，通常是在业务页面代码的最后执行 -->

        <script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm.min.js' charset='utf-8'></script>
        <script src="/js/sm-extend.min.js"></script>
    </form>
</body>
    <script type='text/javascript' src='http://res.wx.qq.com/open/js/jweixin-1.2.0.js'></script>
    <script type='text/javascript'>


        var conf = [];
        $.ajax({
            type: "post", //要用post方式                 
            url: "MyBusiness.aspx/getConf",//方法所在页面和方法名
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: "{'url':'" + window.location.href.split('#')[0] + "'}",
            cache: false,
            async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
            success: function (data) {
                conf = eval("(" + data.d + ")");//将字符串转为json
            }
        });

        wx.config({
            debug: false,
            appId: conf.appid,
            timestamp: conf.timestamp,
            nonceStr: conf.noncestr,
            signature: conf.signature,
            jsApiList: ['scanQRCode']
        });

    </script>

</html>
