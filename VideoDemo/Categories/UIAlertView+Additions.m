//
//  UIAlertView+Additions.m
//  ExtensionAlertView
//
//  Created by 余新闻 on 15-2-5.
//  Copyright (c) 2015年 Adways. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <objc/runtime.h>


static void* UIAlertViewKey = @"UIAlertViewKey";

@implementation UIAlertView (Additions)

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelBtnName:(NSString *)cancelBtnName callBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelBtnName otherButtonTitles: nil];
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelBtnName:(NSString *)cancelBtnName otherBtnName:(NSString *)otherBtnName callBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelBtnName otherButtonTitles: otherBtnName, nil];
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}


+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonName otherButtonTitles: otherButtonTitles, nil];
    NSString *other = nil;
    va_list args;
    if (otherButtonTitles)
    {
        va_start(args, otherButtonTitles);
        while (other == va_arg(args, NSString*))
        {
            [alert addButtonWithTitle:other];
        }
        va_end(args);
    }
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}


- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
{
    
    [self willChangeValueForKey:@"callbackBlock"];
      objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (self.alertViewCallBackBlock)
    {
        self.alertViewCallBackBlock(buttonIndex);
    }
}


@end
