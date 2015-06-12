//
//  NearBySearchViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-11.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "NearBySearchViewController.h"
#import "UIView+Alert.h"
#import "BMapKit.h"

@interface NearBySearchViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
- (IBAction)uploadMyloc;
@property(strong, nonatomic)BMKLocationService* locService;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *street;
@property(assign, nonatomic)CLLocationCoordinate2D currentLocation;
@property(strong, nonatomic)BMKGeoCodeSearch *geocodesearch;
- (IBAction)willSearch;

@end

@implementation NearBySearchViewController

-(void)setCurrentLocation:(CLLocationCoordinate2D)currentLocation{
    _currentLocation = currentLocation;
    [self onClickReverseGeocode:currentLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone4sCity"]];
    self.locService = [[BMKLocationService alloc]init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillAppear:(BOOL)animated
{

    _geocodesearch.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _geocodesearch.delegate = nil;

    _locService.delegate = nil;
    
}
- (IBAction)rangeValue:(id)sender {
    UISlider *slide = (UISlider *)sender;
    
    self.rangeDisplay.text = [NSString stringWithFormat:@"%d",(int)slide.value];
}

- (IBAction)quantityChange:(id)sender {
    
    UISlider *slide = (UISlider *)sender;
    
    self.quantityDisplay.text = [NSString stringWithFormat:@"%d",(int)slide.value];
}
- (IBAction)uploadMyloc {
    
    [self.locService startUserLocationService];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //self.currentLocation = userLocation.location.coordinate;

    self.currentLocation = CLLocationCoordinate2DMake(39.915101, 116.403981);
    [self.locService stopUserLocationService];
}
-(void)onClickReverseGeocode:(CLLocationCoordinate2D)point
{
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = point;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == 0) {
        
            self.city = [NSString stringWithFormat:@"%@",result.addressDetail.city];
            self.street = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        
        
    }
}
- (IBAction)willSearch {
    
    
}
@end
