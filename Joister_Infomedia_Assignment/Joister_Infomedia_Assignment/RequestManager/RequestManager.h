//
//  RequestManager.h
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject
+(NSMutableURLRequest *)loginRequestWithUserName:(NSString *)userName andPassword:(NSString *)password;
+(NSMutableURLRequest *)locationsRequestWithC:(NSString *)c andK:(NSString *)k;
@end
