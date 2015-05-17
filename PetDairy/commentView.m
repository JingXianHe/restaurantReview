//
//  commentView.m
//  PetDairy
//
//  Created by Tommy on 2015-05-12.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "commentView.h"

@implementation commentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)unsatisfied:(id)sender {
    self.firstBtn.selected = YES;
    self.secondBtn.selected = NO;
    self.thirdBtn.selected = NO;
    self.scores = @1;
    
}

- (IBAction)average:(id)sender {
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = NO;
    self.scores = @2;
    
}

- (IBAction)satisfied:(id)sender {
    self.firstBtn.selected = YES;
    self.secondBtn.selected = YES;
    self.thirdBtn.selected = YES;
    self.scores = @3;
    
}
-(NSNumber *)scores{
    if (_scores == nil) {
        _scores = @0;
    }
    return _scores;
}
@end
