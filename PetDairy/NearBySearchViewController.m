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
#import "PoiViewController.h"
#import "UIViewController+TitleBtn.h"
@interface NearBySearchViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
- (IBAction)uploadMyloc;
@property(strong, nonatomic)BMKLocationService* locService;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *street;
@property(assign, nonatomic)CLLocationCoordinate2D currentLocation;
@property(strong, nonatomic)BMKGeoCodeSearch *geocodesearch;
- (IBAction)willSearch;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;

@property(strong, nonatomic)PoiViewController *poiViewController;
@property(assign, nonatomic)BOOL delegateIsOn;
@property (weak, nonatomic) IBOutlet UITextField *keyText;


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
    self.delegateIsOn = false;
    
    
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

- (IBAction)quantityChange:(id)sender {
    
    UISlider *slide = (UISlider *)sender;
    
    self.quantityDisplay.text = [NSString stringWithFormat:@"%d",(int)slide.value];
}
- (IBAction)uploadMyloc {
    
    [self.locService startUserLocationService];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //self.currentLocation = userLocation.location.coordinate;

    self.currentLocation = CLLocationCoordinate2DMake(23.16667,113.23333);
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
        self.street = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
        self.cityText.text = self.city;
        self.addressText.text = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    }
}
- (IBAction)willSearch {
    self.delegateIsOn = true;
    //prepare navigation bar
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    [item setTintColor:[UIColor brownColor]];
    self.navigationItem.rightBarButtonItem = item;
    
    //prepare data for piosearch
    PoiViewController *poi = [[PoiViewController alloc]init];
    poi.city = self.city;
    poi.street = self.street;
    poi.keyWord = self.keyText.text;
    poi.pageCapacity = self.quantityDisplay.text.intValue;
    self.poiViewController = poi;
    poi.currentLocation = self.currentLocation;
    poi.navHeight = self.navigationController.navigationBar.frame.size.height;

    [self.view addSubview:poi.view];
    
}
-(void)btnClick{
    [self.poiViewController.view removeFromSuperview];
    self.poiViewController = nil;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.delegateIsOn = false;
}
@end
