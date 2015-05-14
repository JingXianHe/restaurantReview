//
//  ScrollViewInnerBtn.h
//  PetDairy
//
//  Created by Tommy on 2015-05-11.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScrollViewInnerBtn;

@protocol ScrollViewInnerBtnDelegate <NSObject>
@optional
-(void)ScrollViewInnerBtnDeletePic:(ScrollViewInnerBtn *)btn;

@end

@interface ScrollViewInnerBtn : UIView
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet UIImageView *InnerPhoto;
@property (weak, nonatomic) id<ScrollViewInnerBtnDelegate>delegate;
@end
