//
//  YXPayObject.h
//  ArtEnjoymentRunLu
//
//  Created by 郏国上 on 2017/12/18.
//  Copyright © 2017年 郏国上. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YXPaylibraryManager/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "LLPaySdk.h"


@protocol YXPayObjectDelegate <NSObject>
    
    @optional
    //微信回调
-(void)WXPayReback:(PayResp *)resp;
    
    //支付宝回调
-(void)aliPayPayReback:(NSDictionary *)dic;
    
    //连连回调
-(void)llPayReback:(LLPayResult)resultCode
              data:(NSDictionary *)dic;
    
    @end


@interface YXPayObject : NSObject
    
    @property(nonatomic,weak)id<YXPayObjectDelegate>delegate;
    
    /**
     * @brief  单列
     */
    
+(YXPayObject*)defaultManager;
    
    
    
    /**
     * @brief  微信支付
     * @param  dic（支付组包）
     dic (例子):
     appid               =@"wxd05954492cae2d96";
     partnerId           =@"1261247601";
     prepayId            =@"wx20160825101224caa894c6870455778909";
     nonceStr            = @"5f93f983524def3dca464469d2cf9f3e";
     timeStamp           = 1472091144;   int类型，注意了！
     package             = @"Sign=WXPay";
     sign                = @"9A6FD2D852F7B413B1636D18CBC6BF2C";
     * @param  WXApiID  和我们bid绑定的微信ID 为部分APP提供更换ID的功能
     */
-(void)wxPayMethod:(NSDictionary *)dic
    　WXApiID:(NSString *)WXApiID;
    
    
    
    /**
     * @brief  支付宝支付
     * @param  str（支付组包）
     dic (例子):
     partner=\"2088021007571014\"&seller_id=\"yxkjservice@caocaokeji.cn\"&out_trade_no=\"15026\"&subject=\"曹操出租车服务费用\"&body=\"该商品的详细描述\"&total_fee=\"1000\"&notify_url=\"http://taxi.51caocao.net/trade/payBackAli.do\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&sign=\"Z2LGMFetKCvx6QnpANSRJVbft4R8xhAhv9DRCJNNnwybAls%2BxLSlAl%2F%2FzcKiS%2BSI7sflvAxFJPJZYZOZHp0afzztAGxlQ%2BVUdra1OzHyIbiTEoK4usIm5mLKMUELOJ208UWwwq%2ByuvISdxOqmfBNGyrmbNVnkK2OBwMbfj0ezKs%3D\"&sign_type=\"RSA\"
     */
-(void)airPayMethod:(NSString *)str
    　       schemeName:(NSString *)schemeName;
    
    
    
    /**
     * @brief  连连支付
     * @param orderDic 拼接一串很奇葩的东西
     * @param ViewController 推出连连支付支付界面的ViewController
     */
    
-(void)llPay:(NSDictionary *)orderDic
ViewController:(UIViewController *)vc;
    
    
    
    
    
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
    
-(BOOL)application:(UIApplication *)app
           openURL:(NSURL *)url
           options:(NSDictionary<NSString *,id> *)options;
    
    
    @end
