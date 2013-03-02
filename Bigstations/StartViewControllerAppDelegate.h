//
//  StartViewControllerAppDelegate.h
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/07.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SListTableViewController.h"

@class StartViewControllerViewController;
@class SListTableViewController;

@interface StartViewControllerAppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navigationController;
    SListTableViewController *sListTableViewCont;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) StartViewControllerViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
