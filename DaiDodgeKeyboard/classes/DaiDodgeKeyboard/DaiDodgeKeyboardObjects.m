//
//  DaiDodgeKeyboardObjects.m
//  DaiDodgeKeyboard
//
//  Created by 啟倫 陳 on 2014/9/1.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiDodgeKeyboardObjects.h"

@implementation DaiDodgeKeyboardObjects
-(UIViewController *)ViewController{
    for (UIView* next = self.observerView; next; next = next.superview) {
        NSLog(@"observerview:%@",self.observerView);
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
