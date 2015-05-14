//
//  ScrollViewInnerBtn.m
//  PetDairy
//
//  Created by Tommy on 2015-05-11.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "ScrollViewInnerBtn.h"
@interface ScrollViewInnerBtn()

@property (weak, nonatomic) IBOutlet UIButton *CoverButton;

- (IBAction)deletePic:(id)sender;

@end

@implementation ScrollViewInnerBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)deletePic:(id)sender {
    UIButton *btn = (UIButton *)sender;
    ScrollViewInnerBtn *view = (ScrollViewInnerBtn *)[btn superview];
    if ([self.delegate respondsToSelector:@selector(ScrollViewInnerBtnDeletePic:)]) {
        [self.delegate ScrollViewInnerBtnDeletePic:view];
    }
    [view removeFromSuperview];
}
@end
