//
//  customButton.h
//  testImgFile
//
//  Created by Tommy on 2015-06-10.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>

@interface customButton : UIButton
@property(assign, nonatomic)CLLocationCoordinate2D coordinate;
@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *subTitle;
@end
