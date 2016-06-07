//
//  iOSHelper.m
//  C5
//
//  Created by Akshay S Shrirao on 05/02/16.
//  Copyright © 2016 Apero Technologies. All rights reserved.
//

#import "iOSHelper.h"

@implementation iOSHelper


+(void)setLeftViewForTextField:(UITextField *)txt {
	UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, txt.frame.size.height)];
	v.backgroundColor = txt.backgroundColor;
	txt.leftViewMode = UITextFieldViewModeAlways;
	txt.leftView = v;
}

+(void)setBorderForTextField:(UITextField *)txt{
    txt.layer.borderWidth = 1.0;
	txt.layer.borderColor = [iOSHelper pxColorWithHexValue:APP_BorderCOLOR].CGColor;
}

+(void)setLeftIcon:(NSString *)icon IsIcon:(BOOL)isIcon ForTextField:(UITextField *)textField {
	UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
	
	if (isIcon) {
		UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 30, 30)];
		[iconView setImage:[UIImage imageNamed:icon]];
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		[v addSubview:iconView];
	}else {
		UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 30)];
		lbl.text  = icon;
		lbl.font = [UIFont boldSystemFontOfSize:17];
		lbl.textColor = [UIColor blackColor];
		v.frame = CGRectMake(0, 0, lbl.frame.size.width, 45);
		lbl.backgroundColor=[UIColor whiteColor];
		[v addSubview:lbl];
	}
	textField.leftViewMode = UITextFieldViewModeAlways;
	textField.leftView = v;
}

+(void)setShadowForView:(UIView *)v {
	// drop shadow
	v.layer.borderWidth = 0.5;
	v.layer.borderColor = [UIColor lightGrayColor].CGColor;
	[v.layer setShadowColor:[UIColor darkGrayColor].CGColor];
	[v.layer setShadowOpacity:0.6];
	[v.layer setShadowRadius:1.5];
	[v.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

+(UIColor*)pxColorWithHexValue:(NSString*)hexValue
{
	//Default
	UIColor *defaultResult = [UIColor blackColor];
	
	//Strip prefixed # hash
	if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
		hexValue = [hexValue substringFromIndex:1];
	}
	//Determine if 3 or 6 digits
	NSUInteger componentLength = 0;
	if ([hexValue length] == 3)
	{
		componentLength = 1;
	}
	else if ([hexValue length] == 6)
	{
		componentLength = 2;
	}
	else
	{
		return defaultResult;
	}
	
	BOOL isValid = YES;
	CGFloat components[3];
	
	//Seperate the R,G,B values
	for (NSUInteger i = 0; i < 3; i++) {
		NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
		if (componentLength == 1) {
			component = [component stringByAppendingString:component];
		}
		NSScanner *scanner = [NSScanner scannerWithString:component];
		unsigned int value;
		isValid &= [scanner scanHexInt:&value];
		components[i] = (CGFloat)value / 256.0f;
	}
	
	if (!isValid) {
		return defaultResult;
	}
	
	return [UIColor colorWithRed:components[0]
						   green:components[1]
							blue:components[2]
						   alpha:1.0];
}

+(UIColor *)appBorderColor {
	return [iOSHelper pxColorWithHexValue:APP_BorderCOLOR];
}

+(UIColor *)appBGColor {
	return [iOSHelper pxColorWithHexValue:APP_BGCOLOR];
}

+(UIColor *)navBGColor {
	return [iOSHelper pxColorWithHexValue:APP_NAVCOLOR];
}

+(UIColor *)HighlightedColor{
return [iOSHelper pxColorWithHexValue:HighlightedCOLOR];
}


+(NSMutableDictionary *)getDictionaryFromJsonFile:(NSString *)fileName {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSMutableDictionary *dictionary  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	return dictionary;
}

+(void)printDoc {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile: path];
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    if(pic && [UIPrintInteractionController canPrintData: myData] ) {
        
        
        //TODO: Set delegate before use
        //pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            //self.content = nil;
            if (!completed && error) {
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
        
    };
    
}

+(void)showViewWithAnimation:(UIView *)view WithFrame:(CGRect)frame{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

+(NSString *)getTextFromChar:(unichar)character {
	NSString *string = [NSString stringWithFormat:@"%C",character];
	return string;
}

+(UIFont *) iconFont :(CGFloat)fontSize {
	UIFont *f =  [UIFont fontWithName:@"FontAwesome" size:fontSize];
	return f;
}

+(void)registerForKeyboardNotificationsForViewController:(id)controller {
    [[NSNotificationCenter defaultCenter] addObserver:controller
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

+ (void)deregisterFromKeyboardNotificationsForViewController:(id)controller {
    [[NSNotificationCenter defaultCenter] removeObserver:controller
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:controller
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

+(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message ForViewController:(UIViewController *)viewController {
    if ([UIAlertController class])
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:ok];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
else
{
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert1 show];
    
}

}


+(UIImage *)scaleAndRotateImage:(UIImage *)image {
	int kMaxResolution = 640; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = roundf(bounds.size.width / ratio);
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = roundf(bounds.size.height * ratio);
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

+(NSString *)getFilePathFromFileName:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    return filePath;
}

+(NSString *)removeWhiteSpaceAndNewlinespaceFromString:(NSString *)string{
		NSString *trimmedString = [string stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return trimmedString;
}

//+(NSMutableArray *)createFabricsReqArray {
//  NSMutableArray *arrayOfRequest = [[NSMutableArray alloc]init];
//    
//    int totalItems = 50;
//    
//    NSInteger totalReqDicts =(appDelegate.listOfFabrics.count/totalItems);
//    int arrayCount =(int) appDelegate.listOfFabrics.count;
//    NSInteger m = (arrayCount% totalItems);
//    if (m>0) {
//        totalReqDicts = totalReqDicts +1;
//    }
//    totalReqDicts = totalReqDicts;
//    
//    for (int i=1; i<=totalReqDicts;i++) {
//        NSMutableArray *a =[[NSMutableArray alloc ]init];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//        
//        NSInteger StartIndex=i * totalItems-totalItems;
//        NSInteger EndIndex=StartIndex +totalItems;
//        if (EndIndex > [appDelegate.listOfFabrics count]) {
//            EndIndex=[appDelegate.listOfFabrics count];
//        }
//        for (NSInteger i=StartIndex;i<EndIndex;i++) {
//            [a addObject:[appDelegate.listOfFabrics objectAtIndex:i] ];
//            
//        }
//        [dict setValue:[NSNumber numberWithInt:StartIndex] forKey:@"startIndex"];
//        [dict setValue:[NSNumber numberWithInt:EndIndex] forKey:@"endIndex"];
//        [dict setValue:[NSNumber numberWithInt:i] forKey:@"index"];
//        [dict setValue:a forKey:@"items"];
//        [arrayOfRequest addObject:dict];
//    }
//    return arrayOfRequest;
//}

@end
