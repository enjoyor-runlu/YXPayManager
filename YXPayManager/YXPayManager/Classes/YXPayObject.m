//
//  YXPayObject.m
//  ArtEnjoymentRunLu
//
//  Created by 郏国上 on 2017/12/18.
//  Copyright © 2017年 郏国上. All rights reserved.
//

#import "YXPayObject.h"



@interface YXPayObject()<LLPaySdkDelegate>
    {
        BOOL aliRebackSuccess;//支付宝是否回调，防止两次回调
        BOOL wxRebackSuccess;//微信是否回调，防止两次回调
        BOOL llRebackSuccess;//连连是否回调，防止两次回调
        NSString *wxID;
        
    }
    
    
    
    @end


@implementation YXPayObject
    @synthesize delegate;
    
#pragma  mark - 单列创建
    
    static YXPayObject *sharedUserData = nil;
    
+(YXPayObject*)defaultManager
    {
        if (sharedUserData == nil) {
            sharedUserData = [[super allocWithZone:NULL] init];
            //微信支付注册
            
        }
        return sharedUserData;
    }
    
    
    
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedUserData == nil)
        {
            sharedUserData = [super allocWithZone:zone];
            
            return sharedUserData;
        }
    }
    return nil;
}
    
    //为确保 每次返回的都是同一块地址
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
    
    
    
#pragma  mark - 支付方式
    //微信支付
-(void)wxPayMethod:(NSDictionary *)dic
           WXApiID:(NSString *)WXApiID
    {
        if(!dic || ![dic isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        
        if(![wxID isEqualToString:WXApiID])
        {
            wxID = WXApiID;
            [WXApi registerApp:wxID withDescription:@"yixiang"];
        }
        
        wxRebackSuccess = NO;
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dic objectForKey:@"appid"];
        req.partnerId           = [dic objectForKey:@"partnerid"];
        req.prepayId            = [dic objectForKey:@"prepayid"];
        req.nonceStr            = [dic objectForKey:@"noncestr"];
        req.timeStamp           = [[dic objectForKey:@"timestamp"] intValue];
        req.package             = [dic objectForKey:@"packageKey"];
        req.sign                = [dic objectForKey:@"sign"];
        
        BOOL flag= [WXApi sendReq:req];
        if (!flag)
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"信息" message:@"没有安装微信" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    }
    
    
    //支付宝支付
-(void)airPayMethod:(NSString *)str
         schemeName:(NSString *)schemeName
    {
        aliRebackSuccess = NO;
        
        
        [[AlipaySDK defaultService] payOrder:str fromScheme:schemeName callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            if (!aliRebackSuccess) {
                aliRebackSuccess= YES;
                if ([self.delegate respondsToSelector:@selector(aliPayPayReback:)]) {
                    [self.delegate aliPayPayReback:resultDic];
                }
            }
            
        }];
    }
    
    
    //连连支付
-(void)llPay:(NSDictionary *)orderDic
ViewController:(UIViewController *)vc
    {
        llRebackSuccess = NO;
        
        [LLPaySdk sharedSdk].sdkDelegate = self;
        
        //接入什么产品就传什么LLPayType
        [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:vc
                                                  withPayType:LLPayTypeQuick
                                                andTraderInfo:orderDic];
    }
    
    
#pragma  mark - 支付回调
    
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    
    if (!llRebackSuccess)
    {
        llRebackSuccess= YES;
        if ([self.delegate respondsToSelector:@selector(llPayReback:data:)]) {
            [self.delegate llPayReback:resultCode data:dic];
        }
    }
}
    
    
-(void)wxPaySuccess:(PayResp *)resp
    {
        
        if (!wxRebackSuccess) {
            wxRebackSuccess= YES;
            if ([self.delegate respondsToSelector:@selector(WXPayReback:)]) {
                [self.delegate WXPayReback:resp];
            }
        }
        
    }
    
-(void)airPaySuccess:(NSDictionary *)dic
    {
        if (!aliRebackSuccess) {
            aliRebackSuccess= YES;
            if ([self.delegate respondsToSelector:@selector(aliPayPayReback:)]) {
                [self.delegate aliPayPayReback:dic];
            }
        }
    }
    
    
    
#pragma  mark - 支付完成回调 微信 支付宝
    //设备已安装支付宝客户端情况下,处理支付宝客户端返回的 url。
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
    {
        
        if ([sourceApplication isEqualToString:@"com.tencent.xin"])
        {
            NSString *urlString = [url absoluteString];
            NSRange range = [urlString rangeOfString:@"pay"];
            if(range.length > 0)
            {
                //跳转微信进行支付，处理支付结果
                return  [WXApi handleOpenURL:url delegate:self];
            }
        }else if([sourceApplication isEqualToString:@"com.alipay.iphoneclient"])
        {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                
                if (resultDic != nil)
                [[YXPayObject defaultManager] airPaySuccess:resultDic];
                
            }];
            return YES;
        }
        return YES;
    }
    
-(BOOL)application:(UIApplication *)app
           openURL:(NSURL *)url
           options:(NSDictionary<NSString *,id> *)options
    {
        if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"])
        {
            NSString *urlString = [url absoluteString];
            NSRange range = [urlString rangeOfString:@"pay"];
            if(range.length > 0)
            {
                //跳转微信进行支付，处理支付结果
                return  [WXApi handleOpenURL:url delegate:self];
            }
        }else if([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.alipay.iphoneclient"])
        {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                if (resultDic != nil)
                [[YXPayObject defaultManager] airPaySuccess:resultDic];
            }];
        }
        return YES;
    }
    
    
#pragma  mark  微信Deleagte这个回调必须在这里写
-(void)onResp:(PayResp *)resp
    {
        //启动微信支付的response
        if([resp isKindOfClass:[PayResp class]]){
            //支付返回结果，实际支付结果需要去微信服务器端查询
            [[YXPayObject defaultManager] wxPaySuccess:resp];
        }
    }@end
