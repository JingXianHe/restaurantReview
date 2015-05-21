//
//  DetailScrollView.m
//  PetDairy
//
//  Created by Tommy on 2015-05-21.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "DetailScrollView.h"
#import "DeTailImgView.h"

@implementation DetailScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    
    

    
}
-(void)didAddSubview:(UIView *)subview{
    int index = 0;
    CGFloat btnWidth = 80.0;
    CGFloat containWidth = self.frame.size.width;
    int itemNum = 3;
    CGFloat padding = (containWidth - itemNum*btnWidth)/(itemNum+1);
    
    
    for (id item in self.subviews) {
        if([item isKindOfClass:[DeTailImgView class]]) {
            DeTailImgView *btn = (DeTailImgView *)item;
            int lIndex = index % itemNum;
            int cIndex = index / itemNum;
            NSLog(@"%d -- %d", lIndex, cIndex);
            btn.frame = CGRectMake(lIndex*(btnWidth+padding)+padding, cIndex*(padding+btnWidth), btnWidth, btnWidth);
            
            index++;
        }
        
        
    }
    
    self.contentSize = CGSizeMake(containWidth, (index/itemNum+1)*(btnWidth+padding) + padding);
}

@end
