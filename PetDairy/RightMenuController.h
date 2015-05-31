//
//  RightMenuController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-05.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface RightMenuController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *postContentBtn;
@property(copy, nonatomic)NSString *content;
@property(nonatomic, assign)CGFloat xOffet;
/**
 *  右边菜单全部显示出来
 */
- (void)didShow;
@end
