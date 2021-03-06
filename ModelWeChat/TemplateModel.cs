﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeChat.Common;
using WeChat.Entity;
using WeChat.ModelBusi;

namespace WeChat.ModelWeChat
{
    /// <summary>
    /// 模板消息推送
    /// </summary>
    public static class TemplateModel
    {
        public static bool taskFlag = false;

        public static void ExcuteSubcirbePush_single()
        {
            try
            {
                List<SubcribeInfoEn> sublist = SubscribeModel.getSubscribeTask();
                foreach (SubcribeInfoEn sub in sublist)
                {
                    //var data = new
                    //{
                    //    first = new TemplateDataItem("您好，您订阅的" + sub.SubsType + "已触发"),
                    //    keyword1 = new TemplateDataItem(sub.Cusno),
                    //    keyword2 = new TemplateDataItem(sub.Status),
                    //    remark = new TemplateDataItem("触发时间：" + sub.TriggerTime.ToString())
                    //};
                    //sub.TemplateId = "-GdghWwMXHwOE_hu1xxm2H5hRDGGRTQwTuGoSIg8xww";
                    string subcode = "";
                    if (sub.SubsType == "报关状态")
                    {
                        subcode = sub.DeclarationCode;
                    }
                    else
                    {
                        subcode = sub.OrderCode;
                    }
                    string busiblno = getBusiBlno(sub);
                    var data = new
                    {
                        first = new TemplateDataItem("您好，您订阅的状态已触发"),
                        keyword1 = new TemplateDataItem(subcode),
                        keyword2 = new TemplateDataItem(sub.BusiUnitName),
                        keyword3 = new TemplateDataItem(sub.Contractno),
                        keyword4 = new TemplateDataItem(busiblno),
                        keyword5 = new TemplateDataItem(sub.Status),
                        remark = new TemplateDataItem("触发时间：" + sub.TriggerTime.ToString())

                    };
                    sub.TemplateId = "1i5IvENyqxo349wlgluja4skxORiGSB6M5GD_fLeoKk";
                    string url = "";
                    if(sub.SubsType=="业务状态"||sub.SubsType=="物流状态")
                    {
                        url = @"http://gwy.jishiks.com/Page/MyBusiness/SubscribeDetail.aspx?code=" + sub.OrderCode;
                    }
                    else
                    {
                        url = @"http://gwy.jishiks.com/Page/DeclSubsDetail.aspx?code=" + sub.DeclarationCode;
                    }
                    SendMassMsgResultEn msg = SendTemplateMessage(TokenModel.AccessToken, sub.Openid, sub.TemplateId, data,url);
                    if (msg.errcode == "0")
                    {
                        SubscribeModel.updateSubscirbeInfo(sub.Id);
                    }
                    LogHelper.Write("TemplateModel_订阅推送回执：" + msg.errcode);
                }
            }
            catch(Exception e)
            {
                LogHelper.Write("TemplateModel_订阅推送异常：" + e.Message);
            }
            
        }

        private static string getBusiBlno(SubcribeInfoEn sub)
        {
            string str="";
            switch(sub.BusiType)
            {
                case "10":
                    str = "空出/" + sub.Totalno + "_" + sub.Divideno;
                    break;
                case "11":
                    str = "空进/" + sub.Totalno + "_" + sub.Divideno;
                    break;
                case "20":
                    str = "海出/" + sub.SecondLadingBillno;
                    break;
                case "21":
                    str = "海进/" + sub.SecondLadingBillno;
                    break;
                case "30":
                    str = "陆出/" + sub.LandLadingno;
                    break;
                case "31":
                    str = "陆进/" + sub.LandLadingno;
                    break;
                case "40":
                    str = "国内出口";
                    break;
                case "41":
                    str = "国内进口";
                    break;
                case "50":
                    str = "特殊区域出口";
                    break;
                case "51":
                    str = "特殊区域进口";
                    break;


            }
            return str;
        }
        public static void ExcuteLoginExceptionPush_single()
        {
            try
            {
                List<LoginExceptionEn> sublist = UserModel.getLoginExceptionTask();
                foreach (LoginExceptionEn sub in sublist)
                {
                    var data = new
                    {
                        first = new TemplateDataItem("您好，您的账号在异地登录！"),
                        keyword1 = new TemplateDataItem(sub.LoginNickName),
                        keyword2 = new TemplateDataItem(sub.CreateTime.ToString()),
                        remark = new TemplateDataItem("请及时确认，注意账号安全。")

                    };

                    SendMassMsgResultEn msg = SendTemplateMessage(TokenModel.AccessToken, sub.OldOpenId, "lo_I8kOZqOPfNxFcBTd0wGt_WKGZ5ZXxvdE-iEx2uG4", data, "");
                    if (msg.errcode == "0")
                    {
                        UserModel.updateLoginExceptionInfo_success(sub.ID);
                    }
                    else
                    {
                        UserModel.updateLoginExceptionInfo_failure(sub.ID);
                    }
                }
            }
            catch (Exception e)
            {
                LogHelper.Write("TemplateModel_异常登录推送异常：" + e.Message);
            }
        }


        public static void ExcuteSubcirbePush_batch()
        {
            if (taskFlag)
                return;
            taskFlag = true;//已经运行
            LogHelper.Write("进入订阅执行...");
            while (taskFlag)
            {
                List<SubcribeInfoEn> sublist = SubscribeModel.getSubscribeTask();
                foreach (SubcribeInfoEn sub in sublist)
                {
                    var data = new
                    {
                        type = new TemplateDataItem(sub.SubsType,"#ff0000"),
                        cusno = new TemplateDataItem(sub.Cusno),
                        tiggertime = new TemplateDataItem(sub.TriggerTime.ToString()),
                        status = new TemplateDataItem(sub.Status)
                    };
                    //var obj = JsonHelper.SerializeObject(data);
                   
                    if (sub.SubsType == "物流状态")
                    {
                        sub.TemplateId = "2W7nYI371TSk18pLLubXelXz59wA3yMxoWq6o9uLYXY";
                    }
                    if (sub.SubsType == "报关状态")
                    {
                        sub.TemplateId = "PDpzPNCQdKFyyxTXCxZphl9Vor2mkgfUf-CLqPlLk8E";
                    }
                    if (sub.SubsType == "业务状态")
                    {
                        sub.TemplateId = "82bKjSd9Iyxdi0JPZMvUZ3zwmuleev6PfXimPfyb7aE";
                    }

                    SendMassMsgResultEn msg = SendTemplateMessage(TokenModel.AccessToken, sub.Openid, sub.TemplateId, data, "http://weixin.qq.com/download");
                    if (msg.errcode == "0")
                    {
                        SubscribeModel.updateSubscirbeInfo(sub.Id);
                    }
                }
                System.Threading.Thread.Sleep(5000);
            }
        }

        /// <summary>
        /// 模板消息仅用于公众号向用户发送重要的服务通知，只能用于符合其要求的服务场景中，如信用卡刷卡通知，商品购买成功通知等。
        /// 不支持广告等营销类消息以及其它所有可能对用户造成骚扰的消息。
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="accessToken">访问凭证</param>
        /// <param name="openId"></param>
        /// <param name="templateId">在公众平台线上模板库中选用模板获得ID</param>
        /// <param name="data"></param>
        /// <param name="url">，URL置空，则在发送后，点击模板消息会进入一个空白页面（ios），或无法点击（android）。</param>
        /// <param name="topcolor"></param>
        /// <returns></returns>
        public static SendMassMsgResultEn SendTemplateMessage(string accessToken, string openId, string templateId, object data, string url, string topcolor = "#173177")
        {
            var postUrl = string.Format("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token={0}", accessToken);
            var msgData = new TemplateDataEn()
            {
                touser = openId,
                template_id = templateId,
                topcolor = topcolor,
                url = url,
                data = data
            };
            string postData = JsonHelper.SerializeObject(msgData);
            string str = WeChatHelper.SendHttpRequest(postUrl, postData);
            SendMassMsgResultEn result = JsonHelper.DeserializeJsonToObject<SendMassMsgResultEn>(str);
            return result;
        }

        public class TemplateDataItem
        {
            public string value { get; set; }
            public string color { get; set; }
            public TemplateDataItem(string val, string col = "#0000FF")
            {
                value = val;
                color = col;
            }
        }
    }
}