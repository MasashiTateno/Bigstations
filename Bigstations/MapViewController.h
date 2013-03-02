//
//  MapViewController.h
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/11.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate,UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UILabel *mapCoordinateLabel;
@property (retain, nonatomic) IBOutlet UILabel *mapPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *mapRegionLabel;
@property (retain, nonatomic) IBOutlet UISwitch *headingSwitch;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scroller;

@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, retain) NSMutableArray *addressesArray;
@property (retain, nonatomic) IBOutlet UITextField *placeNameText;
@property (retain, nonatomic) NSString *latitudeText;
@property (retain, nonatomic) NSString *longitudeText;

- (IBAction)panUp:(UIButton *)sender;
- (IBAction)panRight:(UIButton *)sender;
- (IBAction)panDown:(UIButton *)sender;
- (IBAction)panLeft:(UIButton *)sender;
- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)resetSliderValue:(UISlider *)sender;
- (IBAction)goToTokyoTower:(UIButton *)sender;
- (IBAction)headingSwitchChanged:(UISwitch *)sender;
- (IBAction)backButtonDidPush:(id)sender;
-(void)moveToSelectedLocationOfCell :(CLLocationDegrees)latitude :(CLLocationDegrees)longitude;

- (IBAction)searchPlaceName:(id)sender;
- (IBAction)convertCoordinate:(id)sender;


@end