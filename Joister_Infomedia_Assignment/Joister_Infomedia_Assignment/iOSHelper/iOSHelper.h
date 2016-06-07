//
//  iOSHelper.h
//  C5
//
//  Created by Akshay S Shrirao on 05/02/16.
//  Copyright © 2016 Apero Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define APP_BorderCOLOR @"#49C9AE"
#define APP_NAVCOLOR @"#49C9AE"
#define HighlightedCOLOR @"49C9AE"
#define APP_BGCOLOR @"#EAEAEA"
#define ARROW 0xf054
#define DOWN_ARROW 0xf107
#define CHECKMARK  0xf00c
#define UNLOCK 0xf13e
#define LOCK 0xf023
#define UP_ARROW 0xf106
#define SQUARE 0xf096
#define CHECK_SQUARE 0xf046

@interface iOSHelper : NSObject
+(void)setLeftViewForTextField:(UITextField *)txt;
+(void)setBorderForTextField:(UITextField *)txt;
+(void)setLeftIcon:(NSString *)icon IsIcon:(BOOL)isIcon ForTextField:(UITextField *)textField;
+(void)setShadowForView:(UIView *)v ;
+(void)showViewWithAnimation:(UIView *)view WithFrame:(CGRect)frame;

+(void)registerForKeyboardNotificationsForViewController:(id)controller;
+ (void)deregisterFromKeyboardNotificationsForViewController:(id)controller;

+(UIColor*)pxColorWithHexValue:(NSString*)hexValue;

+(NSMutableDictionary *)getDictionaryFromJsonFile:(NSString *)fileName;

+(UIColor *)appBorderColor;
+(UIColor *)appBGColor;
+(UIColor *)navBGColor;
+(UIColor *)HighlightedColor;

+(UIFont *) iconFont :(CGFloat)fontSize;
+(NSString *)getTextFromChar:(unichar)character ;

+(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message ForViewController:(UIViewController *)viewController;

+(UIImage *)scaleAndRotateImage:(UIImage *)image;
+(NSString *)getFilePathFromFileName:(NSString *)filename;
+(NSString *)removeWhiteSpaceAndNewlinespaceFromString:(NSString *)string;
+(NSMutableArray *)createFabricsReqArray;
@end
