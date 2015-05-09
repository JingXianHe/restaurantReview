//
//  PhotoesView.m
//  PetDairy
//
//  Created by Tommy on 2015-05-08.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "PhotoesView.h"

@implementation PhotoesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{

    
    int index = 0;
    CGFloat imageH = self.frame.size.height;
    for (id item in self.subviews) {
        if (index !=0) {
            UIImageView *btn = (UIImageView *)item;
        btn.frame = CGRectMake((index-1)*imageH, 0, imageH, imageH);
        
        }
        index++;

    }

    self.contentSize = CGSizeMake(imageH*(index-1), imageH);
    
}
@end
