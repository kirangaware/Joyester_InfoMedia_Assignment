//
//  AppDelegate.m
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import "AppDelegate.h"
#import "RequestManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeDB];
    
    self.locations = [[NSMutableArray alloc]init];
    return YES;
}

-(void)initializeDB
{
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"JI_DB.sqlite"];
    _dbOperations = [[DBOperations alloc]init];
}

-(BOOL)isConnectedToInternetForViewConrtoller:(UIViewController *)viewController showMessage:(BOOL)isMessage {
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [r currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        if (isMessage) {
            [iOSHelper showAlertWithTitle:@"Alert" Message:@"No internet connection" ForViewController:viewController];
        }
        return NO;
    }else {
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
