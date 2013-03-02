//
//  SListTableViewController.m
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/07.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import "SListTableViewController.h"

@interface SListTableViewController ()

@end

@implementation SListTableViewController

@synthesize eventsArray;
@synthesize addButton;
@synthesize locationManager;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    StartViewControllerAppDelegate *sAppDelegate = (StartViewControllerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *countryName = [[NSString alloc] initWithString:@""];
    NSString *stationName = [[NSString alloc] initWithString:@""];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WorldStations" ofType:@"plist"];
    arrayPathOfCountries = [NSArray arrayWithContentsOfFile:path];
    
    arrayForCnames = [[NSMutableArray alloc] init];
    arrayForSnames = [[NSMutableArray alloc] init];
    locationArray = [[NSMutableArray alloc] init];
    contentsNumArray = [[NSMutableArray alloc] init];
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backButtonDidPush)];
    cellCount = 0;
    firstFlg = YES;
    completeFlg = NO;
    
    numOfContents = 0;
    sectionNum = 0;
    tempNumcellForRow = 0;
    inclement = 0;
    
    
    
//    numOfCells = 0;
    for(NSDictionary *d in arrayPathOfCountries){
        
        [locationArray addObject:[d objectForKey:@"latitude"]];
        [locationArray addObject:[d objectForKey:@"longitude"]];
        
        if (countryName != [d objectForKey:@"country"]) {
            if (numOfContents != 0) {
                NSNumber *tempContentsNum = [NSNumber numberWithInteger:numOfContents];
                [contentsNumArray addObject:tempContentsNum];
                
                numOfContents = 1;
                countryName = [d objectForKey:@"country"];
                stationName =  [d objectForKey:@"stationName"];
                [arrayForCnames addObject:countryName];
                [arrayForSnames addObject:stationName];                
                cellCount++;
            }else{
                numOfContents = 1;
                countryName = [d objectForKey:@"country"];
                stationName =  [d objectForKey:@"stationName"];
                [arrayForCnames addObject:countryName];
                [arrayForSnames addObject:stationName];
                cellCount++;
            }
        }else{
            stationName =  [d objectForKey:@"stationName"];
            [arrayForSnames addObject:stationName];
            numOfContents++;
        }
    }
    
    [contentsNumArray addObject:[NSNumber numberWithInteger:numOfContents]];
    
    
    int j = 0;
    for(NSNumber *n in locationArray)
    {
        NSLog(@"nummy : %d",j);
        j++;
    }
    
//    [arrayForCnames addObject:[NSNull null]];
//    [arrayForSnames addObject:[NSNull null]];
    
//    NSLog(@"numOfContents : %d",numOfContents);
//    NSLog(@"contentsNumarray size : %d",[contentsNumArray count]);
//    NSLog(@"arrayForCnames size : %d",[arrayForCnames count]);
//    NSLog(@"arrayForSnames size : %d",[arrayForSnames count]);
    
    
    //要素確認用
//    int i = 0;
//    for(NSNumber *num in contentsNumArray)
//        {
//            NSLog(@"%d番目のセクションのセル数 : %d",i,[num intValue]);
//            i++;
//        }
//    
//    i = 0;
//        for(NSString *str1 in arrayForCnames)
//        {
//        NSLog(@"配列arrayForCnamesの%d番目の国名 : %@",i,str1);
//            i++;
//        }
//              i=0;
//        for(NSString *str2 in arrayForSnames)
//        {
//            NSLog(@"配列arrayForSnamesの%d番目の駅名 : %@",i,str2);
//            i++;
//        }

    self.title = @"Locations";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:self action:@selector(addEvent)];
//    addButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = addButton;
    [[self locationManager] startUpdatingLocation];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //「Event」エンティティの「managedObjectContext」を「entity」にセット
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:sAppDelegate.managedObjectContext];
    
    //「request」に「entity」を代入
    [request setEntity:entity];
    
    //「sortDescriptor」に、ソート順指定の情報を代入
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    
    //「sortDescriptor」を、「sortDescriptors」に代入（変換）
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,nil];
    
    //「request」に「ソート情報（sortDescriptors）」を代入
    [request setSortDescriptors:sortDescriptors];
    
    // 割り当て済みのオブ ジェクトを解放
    [sortDescriptors release];
    [sortDescriptor release];
    
    //「request」を実行し、結果を可変コピーして、可変配列「mutableFetchResults」に代入
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[sAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // エラーを処理する
    }
    
    //View Controller（self）に、「mutableFetchResults」を設定
    [self setEventsArray:mutableFetchResults];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)addEvent{
    CLLocation *location = [locationManager location];
    if (!location) {
        NSLog(@"no location");
        abort();
    }

    StartViewControllerAppDelegate *sAppDelegate = (StartViewControllerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    List *list = (List *)[NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:sAppDelegate.managedObjectContext];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [list setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
    [list setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
    [list setCreationDate:[NSDate date]];
    [list setSubtitle:[NSString stringWithFormat:@"subtitle"]];
    [list setTitle:[NSString stringWithFormat:@"title"]];
    
    NSError *error = nil;
    if (![sAppDelegate.managedObjectContext save:&error]) {
        NSLog(@"couldn't save");
        abort();
    }
    
    [eventsArray insertObject:eventsArray atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [mainTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(IBAction)backButtonDidPush:(id)sender{
    [self.view removeFromSuperview];
}

- (CLLocationManager *)locationManager {
    if (locationManager != nil) {
        return locationManager;
    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    return locationManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    addButton.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
//    addButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"cellCount : %d\n",cellCount);
    return cellCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection section : %d value : %d\n",section,[[contentsNumArray objectAtIndex:section] integerValue]);
    NSInteger numOfORow = [[contentsNumArray objectAtIndex:section] integerValue];
    sectionNum = section;
    return numOfORow;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"titleForHeaderInSection　section : %d value : %@\n",section,[arrayForCnames objectAtIndex:section]);
    NSString *countryName = [arrayForCnames objectAtIndex:section];
    sectionNum = section;
    return countryName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(cellCount > inclement){
    NSInteger temp = [[contentsNumArray objectAtIndex:inclement] integerValue];
    if (temp == indexPath.row + 1) {
        tempNumcellForRow = tempNumcellForRow + indexPath.row;
        cellnumber =tempNumcellForRow;
        inclement++;	
        NSLog(@"tempnumCellForRow : %d",tempNumcellForRow);
        firstFlg = NO;
    }else{
    cellnumber = tempNumcellForRow + indexPath.row;
    }
    }else{
        completeFlg = YES;
    }
    
    if(completeFlg == NO){
    NSString *cellTitle = [arrayForSnames objectAtIndex:cellnumber];
    cell.textLabel.text = cellTitle;
    
    if (firstFlg == NO) {
        tempNumcellForRow++;
        firstFlg = YES;
    }
    }else{
        NSString *cellTitle = [arrayForSnames objectAtIndex:indexPath.row];
        cell.textLabel.text = cellTitle;
    }
    
    
    
//    NSLog(@"cellnumber : %d",cellnumber);
//    
//    NSLog(@"num : %d string: %@\n",cellnumber,[arrayForSnames objectAtIndex:cellnumber]);
    
//    static NSDateFormatter *dateFormatter = nil; if (dateFormatter == nil) {
//        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    }
//    // 緯度と経度用の数値フォーマッタ
//    static NSNumberFormatter *numberFormatter = nil; if (numberFormatter == nil) {
//        numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//        [numberFormatter setMaximumFractionDigits:3];
//    }
//    
//    List *lists = (List *)[eventsArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dateFormatter stringFromDate:[lists creationDate]];
//    NSString *string = [NSString stringWithFormat:@"%@, %@",
//                        [numberFormatter stringFromNumber:[lists latitude]],
//                        [numberFormatter stringFromNumber:[lists longitude]]]; cell.detailTextLabel.text = string;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    StartViewControllerAppDelegate *sAppDelegate = (StartViewControllerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
        [sAppDelegate.managedObjectContext deleteObject:eventToDelete];
    }
    
    [eventsArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    
    NSError *error = nil;
    if (![sAppDelegate.managedObjectContext save:&error]) {
        NSLog(@"error");
        abort();
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger the_num = 0;
    
    if (indexPath.section != 0){
        for (int i = 0; i < indexPath.section; i++) {
            the_num  = the_num + [[contentsNumArray objectAtIndex:i] intValue];
        }
        
        the_num = the_num + indexPath.row;
    }else{
        the_num = indexPath.row;
    }
    
    CLLocationDegrees latitude = [[locationArray objectAtIndex:the_num*2] doubleValue];
    CLLocationDegrees longitude = [[locationArray objectAtIndex:1 + the_num*2] doubleValue];
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    [self.view addSubview:mapViewController.view];
    [mapViewController moveToSelectedLocationOfCell:latitude :longitude];
}

@end
