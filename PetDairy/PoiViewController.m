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
#import "RouteSearchDemoViewController.h"


@interface PoiViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate>
@property(strong, nonatomic)BMKLocationService* locService;
@property(strong, nonatomic)BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@property(weak, nonatomic)UINavigationController *routeVC;
@end

@implementation PoiViewController

#pragma makr - poisearch
- (BMKPoiSearch *)poisearch
{
    if (!_poisearch) {
        _poisearch = [[BMKPoiSearch alloc] init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - self.navHeight;
    
    BMKMapView* mapView = [[BMKMapView alloc]init];
    mapView.frame = CGRectMake(0, self.navHeight, width, height);
    [self.view addSubview:mapView];
    self.mapView = mapView;
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.locService = [[BMKLocationService alloc]init];
}


#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;

            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
                [self.mapView setZoomLevel:14.0];
                
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        [UIView alertWith:@"错误" message:@"起始点有歧义"];
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    customButton *cBtn = [[customButton alloc]init];
    
    cBtn.coordinate = annotation.coordinate;
    cBtn.title = annotation.title;
    cBtn.subTitle = annotation.subtitle;
    [cBtn addTarget:self action:@selector(goThere:) forControlEvents:UIControlEventTouchUpInside];
    
    [cBtn setImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
    cBtn.frame = CGRectMake(0, 0, 30, 30);
    annotationView.rightCalloutAccessoryView = cBtn;
    
    
    return annotationView;
}
-(void)goThere:(customButton *)cBtn{
    self.targetLocation = cBtn.coordinate;
    [self onClickReverseGeocode:cBtn.coordinate];
    
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

        self.endCity = [NSString stringWithFormat:@"%@",result.addressDetail.city];
        self.endStreet = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
    }
}
-(void)setEndStreet:(NSString *)endStreet{
    _endStreet = endStreet;
    RouteSearchDemoViewController *route = [[RouteSearchDemoViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:route];
    self.routeVC = nav;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        route.startCity.text = self.city;
        route.startPoint.text = self.street;
        route.original = self.currentLocation;
        route.endCity.text = self.endCity;
        route.endPoint.text = self.endStreet;
        route.targetPt = self.targetLocation;
        UIBarButtonItem* btnWayPoint = [[UIBarButtonItem alloc]init];
        btnWayPoint.target = self;
        btnWayPoint.action = @selector(dismissSelfVC);
        btnWayPoint.title = @"返回";
        [btnWayPoint setTintColor:[UIColor brownColor]];
        btnWayPoint.enabled=TRUE;
        route.navigationController.topViewController.navigationItem.leftBarButtonItem = btnWayPoint;
        
    }];

}
-(void)dismissSelfVC{
    [self.routeVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//initiate
-(void)viewDidAppear:(BOOL)animated{
    
//    BMKNearbySearchOption *citySearchOption = [[BMKNearbySearchOption alloc]init];
//    // 检索的页码
//    citySearchOption.pageIndex = 0;
//    // 检索的条数
//    citySearchOption.pageCapacity = self.pageCapacity;
//    citySearchOption.location = self.currentLocation;
//    citySearchOption.radius = 500;
//    citySearchOption.keyword = self.keyWord;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = self.pageCapacity;
    citySearchOption.city= self.city;
    citySearchOption.keyword = self.keyWord;
    
    //citySearchOption.sortType = BMK_POI_SORT_BY_COMPOSITE;

    BOOL flag = [self.poisearch poiSearchInCity:citySearchOption];
    
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
        
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
}

//initiate
- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //_locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    //_locService.delegate = nil;
    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
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
