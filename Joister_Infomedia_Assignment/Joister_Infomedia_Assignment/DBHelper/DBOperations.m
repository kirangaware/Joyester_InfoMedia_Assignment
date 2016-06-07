//
//  DBOperations.m
//  C5
//
//  Created by Akshay S Shrirao on 10/02/16.
//  Copyright © 2016 Apero Technologies. All rights reserved.
//

#import "DBOperations.h"

@interface DBOperations ()
{
}
@end
@implementation DBOperations

-(BOOL)insertLocation:(Location *)location
{
	
	NSString *query=[NSString stringWithFormat:@"insert into Location values(%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,%d,'%@')",location.availability_id, location.availability_type, location.address_one, location.address_two, location.landmark, location.country, location.states, location.city, location.pincode, location.latitude, location.longitude, location.node_id, location.product_id, location.updated];
    
	[appDelegate.dbManager executeQuery:query];
	if (appDelegate.dbManager.affectedRows != 0) {

        NSLog(@"1 Location Inserted");
		return YES;
	}//end of if
	else{
		NSLog(@"Could not execute the query insert Location");
		return NO;
	}// end of else
}


-(NSArray *)getAllLocations{
	NSString *queryToGetLocation=[NSString stringWithFormat:@"select * from Location "];
	;
	 NSArray *resultArray = [[NSArray alloc] initWithArray:[appDelegate.dbManager loadDataFromDB:queryToGetLocation]];
	return resultArray;
}



-(NSArray *)getDistinctValuesFromDBForColumn:(NSString *)columnName {
	
	NSString *query=[NSString stringWithFormat:@"Select distinct %@ from Location where %@ is not null and %@ !='<null>' and %@ !=''", columnName, columnName, columnName, columnName];
	NSArray *result = [[NSArray alloc] initWithArray:[appDelegate.dbManager loadDataFromDB:query]];
	return result;
}

@end
