//
//  LocationsVC.m
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import "LocationsVC.h"
#import "LocationCell.h"
#import "RequestManager.h"
#import "Location.h"
#import "AppDelegate.h"
#import "DetailsVC.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationsVC ()<CLLocationManagerDelegate>
{
    Location *_location;
    CLLocation *currentLocation;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkAuthorizationStatus];
    
    self.title = @"Joispot Locations";

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)checkAuthorizationStatus
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.delegate = self;
        
            //    if(IS_OS_8_OR_LATER >= 8.0)
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
                [self.locationManager requestAlwaysAuthorization];
        
            [self.locationManager startUpdatingLocation];
    }
    else
    {
        [iOSHelper showAlertWithTitle:@"Turn location services ON!" Message:@"To check in, please go to your device settings, tap 'GoldCamera' and turn ON the location services" ForViewController:self];
    }
}

-(void)fetchDataFromDB
{
  NSArray *locations = [appDelegate.dbOperations getAllLocations];
    for (NSArray *a in locations) {
        
    }
}

-(void)login
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [RequestManager loginRequestWithUserName:@"TestUser6" andPassword:@"password"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Resp Dict:%@",responseDictionary);
        [self getLocationsWithResponse:responseDictionary];
        
    }];
    [postDataTask resume];
}

-(void)getLocationsWithResponse:(NSDictionary *)responseDictionary
{
    NSString *c = [responseDictionary valueForKeyPath:@"data.c"];
    NSString *k = [responseDictionary valueForKeyPath:@"data.k"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSMutableURLRequest *request = [RequestManager locationsRequestWithC:c andK:k];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Resp Dict:%@",responseDictionary);
        
        NSArray *locations = [responseDictionary valueForKey:@"locations"];
        NSLog(@"%@",locations);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveLocationsToDB:locations];

        });
        
        
    }];
    [postDataTask resume];
    
}

-(void)saveLocationsToDB:(NSArray *)locations
{
    for (NSDictionary *dict in locations) {
        Location *l = [[Location alloc]initWithDictionary:dict];
        [appDelegate.dbOperations insertLocation:l];
        [appDelegate.locations addObject:l];
    }
    [self.tableView reloadData];

}

-(void)getCurrentLocation {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appDelegate.locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCellId" forIndexPath:indexPath];
    
    // Configure the cell...
    Location *l = appDelegate.locations[indexPath.row];
    cell.lblAddress1.text = l.address_one;
    cell.lblAddress2.text = l.address_two;
    cell.lblLandmark.text = [NSString stringWithFormat:@"landmark - %@",l.landmark];
    cell.lblCity.text = [NSString stringWithFormat:@"%@ -%@",l.city, l.pincode];
    cell.lblDistance.text = [NSString stringWithFormat:@"%f km",[self getDistanceWithLat:[l.latitude doubleValue] andLong:[l.longitude doubleValue]]];
    return cell;
}

-(float)getDistanceWithLat:(long)latitude andLong:(long)longitude
{
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:locB];
    
    float d = distance/1000;
    
    NSLog(@"%f",d);
    return d;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _location = [appDelegate.locations objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ListToDetails" sender:self];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ListToDetails"])
    {
    DetailsVC *details = [segue destinationViewController];
        details.location = _location;
    }
}

#pragma mark CLLocation Delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    currentLocation = newLocation;
    
    if ([appDelegate isConnectedToInternetForViewConrtoller:self showMessage:YES]) {
        [self login];
    }else {
        [self fetchDataFromDB];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}


@end
