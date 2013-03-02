//
//  MapViewController.m
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/11.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
{
    int _lastSliderValue;
}
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize mapCoordinateLabel = _mapCoordinateLabel;
@synthesize mapPointLabel = _mapPointLabel;
@synthesize mapRegionLabel = _mapRegionLabel;
@synthesize headingSwitch = _headingSwitch;
@synthesize placeNameText = _placeNameText;
@synthesize geocoder = _geocoder;
@synthesize addressesArray = _addressesArray;
@synthesize latitudeText = _latitudeText;
@synthesize longitudeText = _longitudeText;
@synthesize scroller = _scroller;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 現在地を利用する (InterfaceBuilderでも指定可能)
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;
    _mapCoordinateLabel.numberOfLines = 0;
    _mapPointLabel.numberOfLines = 0;
    _mapRegionLabel.numberOfLines = 0;
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    // ジオコーディングのインスタンス生成
    _geocoder = [[CLGeocoder alloc] init];
    // 履歴を保持する配列
    _addressesArray = [[NSMutableArray alloc] init];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    [self.view addSubview:self.scroller];
}

- (void)viewDidUnload
{
    _mapView.delegate = nil;
    
    self.mapView = nil;
    self.mapCoordinateLabel = nil;
    self.mapPointLabel = nil;
    self.mapRegionLabel = nil;
    self.headingSwitch = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    _mapView.delegate = nil;
    
    [_mapView release];
    [_mapCoordinateLabel release];
    [_mapPointLabel release];
    [_mapRegionLabel release];
    [_headingSwitch release];
    
    [_scroller release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* 指定された場所が中心になるようにパン */
- (void)mapViewCenterSetX:(CGFloat)x y:(CGFloat)y
{
    CLLocationCoordinate2D coord = [_mapView convertPoint:CGPointMake(x, y) toCoordinateFromView:_mapView];
    [_mapView setCenterCoordinate:coord animated:YES];
    
    if (_headingSwitch.on) {
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    }
}

/* 地図を上にパン */
- (IBAction)panUp:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width / 2;
    CGFloat nextY = 0;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を右にパン */
- (IBAction)panRight:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width;
    CGFloat nextY = _mapView.frame.size.height / 2;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を下にパン */
- (IBAction)panDown:(UIButton *)sender {
    CGFloat nextX = _mapView.frame.size.width / 2;
    CGFloat nextY = _mapView.frame.size.height;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* 地図を左にパン */
- (IBAction)panLeft:(UIButton *)sender {
    CGFloat nextX = 0;
    CGFloat nextY = _mapView.frame.size.height / 2;
    [self mapViewCenterSetX:nextX y:nextY];
}

/* スライダーの変更に合わせて、地図を拡大・縮小する */
- (IBAction)sliderChanged:(UISlider *)sender {
    NSLog(@"%lf", sender.value);
    int value = round(sender.value);
    if (value == _lastSliderValue) {
        sender.value = _lastSliderValue;
        return;
    }
    
    // 左で縮小・右で拡大
    MKCoordinateRegion region = _mapView.region;
    if (value < _lastSliderValue) {
        region.span.latitudeDelta /= 2;
        region.span.longitudeDelta /= 2;
    } else {
        region.span.latitudeDelta *= 2;
        region.span.longitudeDelta *= 2;
        // 最大サイズを超えて拡大してしまうと、落ちるので判定
        if (180 < region.span.latitudeDelta) {
            region.span.latitudeDelta = 180;  // 緯度は180度
        }
        if (360 < region.span.longitudeDelta) {
            region.span.longitudeDelta = 360;  // 経度は360度
        }
    }
    
    [_mapView setRegion:region animated:YES];
    _lastSliderValue = value;
}

/* 離されたときに、スライダーをリセットする*/
- (IBAction)resetSliderValue:(UISlider *)sender {
    _lastSliderValue = 0;
    [sender setValue:0 animated:YES];
}

/* 東京タワーに飛ぶ */
- (IBAction)goToTokyoTower:(UIButton *)sender {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(35.658608, 139.745396);
    MKCoordinateRegion coordRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [_mapView setRegion:coordRegion animated:YES];
}

/* ユーザトラッキング＋ヘディングアップをするかどうか */
- (IBAction)headingSwitchChanged:(UISwitch *)sender {
    if (sender.on) {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    } else {
        _mapView.userTrackingMode = MKUserTrackingModeNone;
    }
}

- (IBAction)backButtonDidPush:(id)sender{
    [self.view removeFromSuperview];
}

-(void)moveToSelectedLocationOfCell :(CLLocationDegrees)latitude :(CLLocationDegrees)longitude{
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion selectedLocation = MKCoordinateRegionMakeWithDistance(coordinates, 100, 100);
    [_mapView setRegion:selectedLocation animated:YES];
}

#pragma mark - MKMapViewDelegate methods

/* 地図が移動しようとするとき */
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図が移動し終えた後 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 地図座標
    MKCoordinateRegion region = [_mapView convertRect:_mapView.frame toRegionFromView:_mapView];
    NSLog(@"lati : %lf \nlongi : %lf",region.center.latitude,region.center.longitude);
    _mapCoordinateLabel.text = [NSString stringWithFormat:@"%lf\n%lf", region.center.latitude, region.center.longitude];
    
    // 表示領域
    _mapRegionLabel.text = [NSString stringWithFormat:@"%lf\n%lf", region.span.latitudeDelta, region.span.longitudeDelta];
    
    // 地図点
    MKMapPoint point = MKMapPointForCoordinate(region.center);
    _mapPointLabel.text = [NSString stringWithFormat:@"%lf\n%lf", point.x, point.y];
}

/* 地図を読み込むとき */
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図を読み終えた後 */
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 地図の読み込みに失敗した場合 */
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

/* 位置情報サービスを開始する前 */
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスを停止した */
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスを更新した */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/* 位置情報サービスの更新に失敗した */
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
}

/* ユーザトラッキングが変更された */
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 移動するとユーザートラッキングが解除されるため、スイッチもオフにする
    if (_mapView.userTrackingMode == MKUserTrackingModeNone) {
        _headingSwitch.on = NO;
    }
}

#pragma ---textFieldDelegate method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger marginFromKeyboard = 10;
    NSInteger keyboardHeight = 400;
    
    CGRect tmpRect = textField.frame;
    if ((tmpRect.origin.y + tmpRect.size.height + marginFromKeyboard + keyboardHeight) > _scroller.frame.size.height) {
        NSInteger yOffset;
        yOffset = keyboardHeight + marginFromKeyboard + tmpRect.origin.y + tmpRect.size.height - _scroller.frame.size.height;
        [_scroller setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_scroller setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma ---geocoding method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    // キーボードを閉じる
    [_placeNameText resignFirstResponder];
}

- (IBAction)searchPlaceName:(id)sender {
    // 住所が正しいかをチェック
    if (![self placeNameIsValid]) {
        return;  // エラーがあれば検索しない
    }
    
    // キーボードを閉じる
    [self hideKeyboard];
    
    // 正ジオコーディングの開始
    [_geocoder geocodeAddressString:_placeNameText.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%s | %@", __PRETTY_FUNCTION__, error);
            [_addressesArray insertObject:[self errorToString:error] atIndex:0];  // 最新のものを先頭に
        } else {
            for (CLPlacemark *p in placemarks) {
                // ログ出力
                NSLog(@"%s", __PRETTY_FUNCTION__);
                [self logPlacemark:p];
                
                _latitudeText = [NSString stringWithFormat:@"%lf",p.location.coordinate.latitude];
                _longitudeText = [NSString stringWithFormat:@"%lf",p.location.coordinate.longitude];
                
                NSLog(@"lati : %@",_latitudeText);
                NSLog(@"longi : %@",_longitudeText);
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([_latitudeText doubleValue], [_longitudeText doubleValue]);
                MKCoordinateRegion coordRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
                [_mapView setRegion:coordRegion animated:YES];
                
                // 履歴に残す
                NSString *formattedAddress = [[p.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@" "];
                [_addressesArray insertObject:formattedAddress atIndex:0];  // 最新のものを先頭に
            }
        }
    }];
}

//- (void)moveToSearchedPlace:(NSString *)latiStr :(NSString *)longiStr{
//    
//    NSInteger lati =　[latiStr intva];
//    
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(35.658608, 139.745396);
//    MKCoordinateRegion coordRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
//    [_mapView setRegion:coordRegion animated:YES];
//}
#pragma mark - input validation methods

/* 入力されている値が、正しい住所情報であるかを判定 */
- (BOOL)placeNameIsValid
{
    // 単純に空欄・スペースのみでないかをチェック
    NSRange range = [_placeNameText.text rangeOfString:@"^\\s*$" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        // 正常
        _placeNameText.textColor = [UIColor blackColor];
        return YES;
    } else {
        // 空欄・スペースのみ
        _placeNameText.textColor = [UIColor redColor];
        return NO;
    }
}

/* 入力されている値が、正しい緯度・経度であるかを判定
 * CLLocationCoordinate2DIsValid だと、緯度か経度のどちらが誤っているかを検知できない
 */
//- (BOOL)coordinateIsValid
//{
//    NSString *coordinateRangeString = @"^[+-]?\\d+(?:\\.\\d+)?$";
//    BOOL latitudeIsValid = YES;
//    BOOL longitudeIsValid = YES;
//    NSRange range;
//    
//    /* 緯度が正しいかをチェック */
//    if (range.location == NSNotFound) {
//        latitudeIsValid = NO;  // 緯度ではない
//    } else {
//        // 範囲内の数値であるか
//        CLLocationDegrees latitude = [_latitudeText.text floatValue];
//        if (latitude < -90 || 90 < latitude) {
//            latitudeIsValid = NO;  // 緯度ではない
//        }
//    }
//    // Viewに反映
//    if (latitudeIsValid) {
//        _latitudeLabel.textColor = [UIColor blackColor];
//    } else {
//        _latitudeLabel.textColor = [UIColor redColor];
//    }
//    
//    /* 経度が正しいかをチェック */
//    range = [_longitudeText.text rangeOfString:coordinateRangeString options:NSRegularExpressionSearch];
//    if (range.location == NSNotFound) {
//        longitudeIsValid = NO;  // 経度ではない
//    } else {
//        // 範囲内の数値であるか
//        CLLocationDegrees longitude = [_longitudeText.text floatValue];
//        if (longitude < -180 || 180 < longitude) {
//            longitudeIsValid = NO;  // 経度ではない
//        }
//    }
//    // Viewに反映
//    if (longitudeIsValid) {
//        _longitudeLabel.textColor = [UIColor blackColor];
//    } else {
//        _longitudeLabel.textColor = [UIColor redColor];
//    }
//    
//    // 緯度・経度の両方が正しい場合のみYES
//    return (latitudeIsValid && longitudeIsValid);
//}

#pragma mark - private methods

/* エラーを文字列に変換 */
- (NSString *)errorToString:(NSError *)error
{
    switch ([error code]) {
        case kCLErrorGeocodeFoundNoResult:
            return @"NoResult";
        case kCLErrorGeocodeFoundPartialResult:
            return @"PartialResult";
        case kCLErrorGeocodeCanceled:
            return @"Canceled";
        default:
            return [error localizedDescription];
    }
}

/* プレースマークの情報をログに残すだけ */
- (void)logPlacemark:(CLPlacemark *)placemark
{
    NSLog(@"addressDictionary: %@", placemark.addressDictionary);
    NSLog(@"administrativeArea: %@", placemark.administrativeArea);
    NSLog(@"areasOfInterest: %@", placemark.areasOfInterest);
    NSLog(@"country: %@", placemark.country);
    NSLog(@"inlandWater: %@", placemark.inlandWater);
    NSLog(@"locality: %@", placemark.locality);
    NSLog(@"name: %@", placemark.name);
    NSLog(@"ocean: %@", placemark.ocean);
    NSLog(@"postalCode: %@", placemark.postalCode);
    NSLog(@"region: %@", placemark.region);
    NSLog(@"subAdministrativeArea: %@", placemark.subAdministrativeArea);
    NSLog(@"subLocality: %@", placemark.subLocality);
    NSLog(@"subThoroughfare: %@", placemark.subThoroughfare);
    NSLog(@"thoroughfare: %@", placemark.thoroughfare);
}


@end