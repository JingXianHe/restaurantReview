//
//  UIViewController+TitleBtn.h
//  PetDairy
//
//  Created by Tommy on 2015-06-15.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TitleBtn)<UIAlertViewDelegate>
@property(weak, nonatomic)UIButton *titleBtn;
-(void)refreshView;
@end
