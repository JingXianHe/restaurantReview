//
//  MapViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-22.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapKit;
- (IBAction)returnBtn;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapKit.delegate = self;
    self.mapKit.rotateEnabled = NO;
    self.mapKit.userTrackingMode = MKUserTrackingModeNone;
    
    
}

-(void)setGeolocation{
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapKit setRegion:region];
    [self.mapKit setCenterCoordinate:center animated:YES];
    MyAnnotation *myAnn = [[MyAnnotation alloc]initWithCoordinates:center title:self.title subTitle:@""];
    [self.mapKit addAnnotation:myAnn];
    [self.mapKit selectAnnotation:myAnn animated:YES];
    
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

- (IBAction)returnBtn {
    [self.view removeFromSuperview];
}
@end
