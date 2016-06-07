//
//  AppDelegate.h
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "DBOperations.h"
#import "Reachability.h"
#import "iOSHelper.h"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@class DBOperations;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DBOperations *dbOperations;
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray *locations;
-(BOOL)isConnectedToInternetForViewConrtoller:(UIViewController *)viewController showMessage:(BOOL)isMessage;
@end

