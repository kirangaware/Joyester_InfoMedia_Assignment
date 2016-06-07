//
//  DetailsVC.h
//  Joister_Infomedia_Assignment
//
//  Created by Kiran Gaware on 02/05/16.
//
//

#import <UIKit/UIKit.h>
#import "Location.h"
@interface DetailsVC : UIViewController
@property (strong,nonatomic) Location *location;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress1;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress2;
@property (weak, nonatomic) IBOutlet UILabel *lblLandmark;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@end
