//
//  Location.h
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *address_one;
@property (strong, nonatomic) NSString *address_two;
@property (strong, nonatomic) NSString *landmark;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *states;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *pincode;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *updated;

@property(nonatomic,assign) int availability_id;
@property(nonatomic,assign) int availability_type;
@property(nonatomic,assign) int node_id;
@property(nonatomic,assign) int product_id;

@end
