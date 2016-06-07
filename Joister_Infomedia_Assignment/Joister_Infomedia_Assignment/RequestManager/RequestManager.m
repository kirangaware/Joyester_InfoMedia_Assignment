//
//  RequestManager.m
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import "RequestManager.h"

@implementation RequestManager

+(NSMutableURLRequest *)loginRequestWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    NSError *error;
    
   
    NSURL *url = [NSURL URLWithString:@"https://unitcom.myjipl.com/com-api/signin"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   // [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *reqData = @{
                              @"username": userName,
                              @"password":password,
                              @"is_mobile": [NSNumber numberWithInt:1],
                              @"os_version": @"5.1.1",
                              @"device_key": @"123456789",
                              @"browser_version": @"",
                              @"device": @"android",
                              @"mobile_app_name": @"Joister",
                              @"remember_me": [NSNumber numberWithBool:1]
                              };
    
//    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"TEST IOS", @"name",
//                             @"IOS TYPE", @"typemap",
//                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:reqData options:0 error:&error];
    [request setHTTPBody:postData];
    
    return request;
    
}

+(NSMutableURLRequest *)locationsRequestWithC:(NSString *)c andK:(NSString *)k
{
    NSError *error;
    
    
    NSURL *url = [NSURL URLWithString:@"https://unitcom.myjipl.com/mobile_api/sync_data"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *reqData = @{
                              @"c": c,
                              @"k":k
                              };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:reqData options:0 error:&error];
    [request setHTTPBody:postData];
    
    return request;
    
}

@end
