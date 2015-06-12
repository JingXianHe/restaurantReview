//
//  PoiViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-06-12.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "PoiViewController.h"
#import "UIView+Alert.h"
#import "BMapKit.h"
#import "customButton.h"

@interface PoiViewController ()
@property(strong, nonatomic)BMKLocationService* locService;
@property(strong, nonatomic)BMKGeoCodeSearch *geocodesearch;

/**
 *  百度地图
 */
@property (nonatomic, strong) BMKMapView* mapView;
/**
 *  检索对象
 */
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@end

@implementation PoiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:mapView];
    self.mapView = mapView;
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.locService = [[BMKLocationService alloc]init];
}

-(void)setCurrentLocation:(CLLocationCoordinate2D)currentLocation{
    _currentLocation = currentLocation;
    BMKNearbySearchOption *citySearchOption = [[BMKNearbySearchOption alloc]init];
    // 检索的页码
    citySearchOption.pageIndex = 0;
    // 检索的条数
    citySearchOption.pageCapacity = 10;
    citySearchOption.location = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
    citySearchOption.radius = 500;
    citySearchOption.keyword = @"餐厅";
    citySearchOption.sortType = BMK_POI_SORT_BY_COMPOSITE;
    
    BOOL flag = [self.poisearch poiSearchNearBy:citySearchOption];
    
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
        
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
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

@end
