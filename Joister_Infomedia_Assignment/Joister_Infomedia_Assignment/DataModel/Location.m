//
//  Location.m
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import "Location.h"

@implementation Location
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setLocationWithDict:dict];
    }
    return self;
}

-(void)setLocationWithDict:(NSDictionary *)dict
{
    self.availability_id = [[dict valueForKey:@"availability_id"] intValue];
    self.availability_type = [[dict valueForKey:@"availability_type"] intValue];
    self.node_id = [[dict valueForKey:@"node_id"] intValue];
    self.product_id = [[dict valueForKey:@"product_id"] intValue];
    
    self.address_one = [dict valueForKey:@"address_one"];
    self.address_two = [dict valueForKey:@"address_two"];
    self.landmark = [dict valueForKey:@"landmark"];
    self.country = [dict valueForKey:@"country"];
    self.states = [dict valueForKey:@"states"];
    self.city = [dict valueForKey:@"city"];
    self.pincode = [dict valueForKey:@"pincode"];
    self.latitude = [dict valueForKey:@"latitude"];
    self.longitude = [dict valueForKey:@"longitude"];
    self.updated = [dict valueForKey:@"updated"];

}
@end
