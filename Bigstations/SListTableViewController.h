//
//  SListTableViewController.h
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/07.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StartViewControllerViewController.h"
#import "List.h"
#import "StartViewControllerAppDelegate.h"
#import "MapViewController.h"

@interface SListTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate,UIApplicationDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>{
//    StartViewControllerAppDelegate *sAppDelegate;
    NSMutableArray *eventsArray;
    NSArray *arrayPathOfCountries;
    CLLocationManager *locationManager;
    UIBarButtonItem *addButton;
    NSInteger numOfCells;
    NSInteger numOfContents;
    NSInteger cellCount;
    NSInteger sectionNum;
    NSInteger tempNumcellForRow;
    NSInteger inclement;
    NSInteger cellnumber;
    NSMutableArray *arrayForCnames;
    NSMutableArray *arrayForSnames;
    NSMutableArray *contentsNumArray;
    NSMutableArray *locationArray;
    IBOutlet UITableView *mainTableView;
    BOOL completeFlg;
    BOOL firstFlg;
}

@property(nonatomic,retain) NSMutableArray *eventsArray;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) UIBarButtonItem *addButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;

-(void)addEvent;
-(IBAction)backButtonDidPush:(id)sender;
@end
