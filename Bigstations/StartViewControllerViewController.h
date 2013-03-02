//
//  StartViewControllerViewController.h
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/07.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SListTableViewController.h"
#import "MapViewController.h"

@interface StartViewControllerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>{
    UIWindow *window;
    UINavigationController *navigationController;
    UIView *startView;
    UIImageView *topImageView;
    UIViewController *sListTableview;
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *favoriteButton;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic,strong) UIViewController *sListTableview;
@property(nonatomic,strong) UIView *startView;
@property (retain, nonatomic) IBOutlet UIImageView *topImageView;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic,strong) MapViewController *mapViewController;

-(void)startButtonDown:(id)sender;
-(void)favoriteButtonDown:(id)sender;

@end
