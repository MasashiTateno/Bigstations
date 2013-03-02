//
//  StartViewControllerViewController.m
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/07.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import "StartViewControllerViewController.h"

@interface StartViewControllerViewController ()

@end

@implementation StartViewControllerViewController
@synthesize topImageView;
@synthesize startView;
@synthesize startButton;
@synthesize favoriteButton;
@synthesize sListTableview;
@synthesize window;
@synthesize mapViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    sListTableview = [[UITableViewController alloc] initWithNibName:@"SListTableViewController" bundle:nil];
    sListTableview = [[SListTableViewController alloc] initWithNibName:@"SListTableViewController" bundle:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"YS-background.png"]];
    [startButton addTarget:self action:@selector(startButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteButton addTarget:self action:@selector(favoriteButtonDown:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view sendSubviewToBack:topImageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)startButtonDown:(id)sender{
    
//    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//	sListTableview = [[SListTableViewController alloc] init];
//	navigationController = [[UINavigationController alloc] initWithRootViewController:sListTableview];
//	
//	[window addSubview:[navigationController view]];
//    [window makeKeyAndVisible];
    [self.view addSubview:sListTableview.view];

}

-(void)favoriteButtonDown:(id)sender{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mapViewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
    } else {
        self.mapViewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
    }
    [self.view addSubview:self.mapViewController.view];
}

@end
