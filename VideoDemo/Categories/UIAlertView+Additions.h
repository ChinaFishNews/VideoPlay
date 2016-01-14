//
//  UIAlertView+Additions.h
//  ExtensionAlertView
//
//  Created by 余新闻 on 15-2-5.
//  Copyright (c) 2015年 Adways. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (Additions)

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;


+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...;


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelBtnName:(NSString *)cancelBtnName callBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock;


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelBtnName:(NSString *)cancelBtnName otherBtnName:(NSString *)otherBtnName callBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock;


@end
