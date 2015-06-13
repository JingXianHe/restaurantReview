//
//  RouteSearchDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RouteSearchDemoViewController : UIViewController<BMKMapViewDelegate, BMKRouteSearchDelegate> {
	IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
}

@property (weak, nonatomic) IBOutlet UITextField *startCity;
@property (weak, nonatomic) IBOutlet UITextField *startPoint;
@property (weak, nonatomic) IBOutlet UITextField *endCity;
@property (weak, nonatomic) IBOutlet UITextField *endPoint;
@property(assign, nonatomic)CLLocationCoordinate2D original;
@property(assign, nonatomic)CLLocationCoordinate2D targetPt;
-(IBAction)onClickBusSearch;
-(IBAction)onClickDriveSearch;
-(IBAction)onClickWalkSearch;
- (IBAction)textFiledReturnEditing:(id)sender;


@end