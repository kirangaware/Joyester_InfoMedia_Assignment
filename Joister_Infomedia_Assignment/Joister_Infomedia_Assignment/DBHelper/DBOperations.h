//
//  DBOperations.h
//  C5
//
//  Created by Akshay S Shrirao on 10/02/16.
//  Copyright © 2016 Apero Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "AppDelegate.h"
@interface DBOperations : NSObject


-(BOOL)insertLocation:(Location *)location;
-(NSArray *)getAllLocations;
-(NSArray *)getDistinctValuesFromDBForColumn:(NSString *)columnName;
@end
