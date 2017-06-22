//
//  DaiDodgeKeyboard+Animation.m
//  DaiDodgeKeyboard
//
//  Created by 啟倫 陳 on 2014/4/28.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiDodgeKeyboard+Animation.h"

#import "DaiDodgeKeyboard+AccessObject.h"

@implementation DaiDodgeKeyboard (Animation)

#pragma mark - class method

//加入inputAccessoryView控制键盘收起
+(UIToolbar *)toorBar:(UIView *)newFirstResponderView{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 30)];
    //粗糙的只判断了三种情况
    if ([newFirstResponderView isKindOfClass:[UITextField class]]) {
        UITextField* tf = (UITextField *)newFirstResponderView;
        tf.inputAccessoryView = toolbar;
        
    }else if ([newFirstResponderView isKindOfClass:[UITextView class]]){
        UITextView *tv = (UITextView *)newFirstResponderView;
        tv.inputAccessoryView = toolbar;
        
    }else if ([newFirstResponderView isKindOfClass:[UISearchBar class]]){
        UISearchBar *bar = (UISearchBar *)newFirstResponderView;
        bar.inputAccessoryView = toolbar;
    }
    //
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MLInputDodger" ofType:@"bundle"];
    NSString *imgPath= [bundlePath stringByAppendingPathComponent:@"retract"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    [toolbar setItems:@[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(selectDone)]]];
    return toolbar;

}

+ (void)changeFirstResponder:(UIView *)newFirstResponderView
{

    //加入toolbar
    [self toorBar:newFirstResponderView];
    //
	if ([self objects].isKeyboardShow) {
		[self dodgeNewView:newFirstResponderView];
		[self objects].firstResponderView = newFirstResponderView;
	} else {
		[self objects].firstResponderView = newFirstResponderView;
	}
    
}
+(void)selectDone{
    [[self objects].firstResponderView resignFirstResponder];
}
+ (void)dodgeKeyboardAnimation
{
    NSLog(@"dodgeKeyboardAnimation:%f",[self objects].observerView.frame.origin.y);
  
    CGFloat currentKeyboardHeight = MAX([self currentKeyboardFrame].origin.x, [self currentKeyboardFrame].origin.y);
    CGRect currentFirstResponderFrame = [self currentFirstResponderFrame:[self objects].firstResponderView];
    CGFloat viewFloor = currentFirstResponderFrame.origin.y + currentFirstResponderFrame.size.height;
    BOOL isCrossOnKeyboard = (viewFloor >= currentKeyboardHeight);
    
    if (isCrossOnKeyboard && [self objects].isKeyboardShow) {
        CGFloat currentShift = viewFloor - currentKeyboardHeight - [self objects].shiftHeight;

        [UIView animateWithDuration:[self objects].keyboardAnimationDutation animations: ^{
            CGRect newFrame = [self objects].observerView.frame;
            newFrame.origin.y = [self objects].observerView.frame.origin.y - currentShift;
            [self objects].observerView.frame = newFrame;
        } completion:^(BOOL finished) {
            [self objects].shiftHeight = -[self objects].observerView.frame.origin.y;
        }];
    } else if (![self objects].isKeyboardShow) {
        [UIView animateWithDuration:[self objects].keyboardAnimationDutation animations: ^{
//            NSLog(@"ViewController:%@",[self objects].ViewController);
          
             [self objects].observerView.frame = [self objects].originalViewFrame;
            
//            if ([self objects].ViewController.topLayoutGuide.length < 64 && [self objects].ViewController.navigationController.navigationBar.frame.size.height >= 64) {
//                
//                [self objects].observerView.frame = CGRectMake(0,[self objects].originalViewFrame.origin.y + [self objects].ViewController.navigationController.navigationBar.frame.size.height + [self objects].ViewController.topLayoutGuide.length, [self objects].originalViewFrame.size.width, [self objects].originalViewFrame.size.height);
//            }else{
//                [self objects].observerView.frame = [self objects].originalViewFrame;
//            }
        } completion:^(BOOL finished) {
            [self objects].shiftHeight = 0;
        }];
    }
}


#pragma mark - private

//做這個 method 的當下, 實際上的 view 已經被上移, 要以被上移的基礎上做考量
+ (void)dodgeNewView:(UIView *)newView
{
	CGFloat currentKeyboardHeight = MAX([self currentKeyboardFrame].origin.x, [self currentKeyboardFrame].origin.y);
    CGRect currentFirstResponderFrame = [self currentFirstResponderFrame:newView];
    CGFloat viewFloor = currentFirstResponderFrame.origin.y + currentFirstResponderFrame.size.height;
    BOOL isCrossOnKeyboard = (viewFloor >= currentKeyboardHeight);
    
    if (isCrossOnKeyboard) {
        CGFloat currentShift = viewFloor - currentKeyboardHeight - [self objects].shiftHeight;

        [UIView animateWithDuration:[self objects].keyboardAnimationDutation animations: ^{
            CGRect newFrame = [self objects].observerView.frame;
            newFrame.origin.y = [self objects].observerView.frame.origin.y - currentShift;
            [self objects].observerView.frame = newFrame;
        } completion:^(BOOL finished) {
            [self objects].shiftHeight = -[self objects].observerView.frame.origin.y;
        }];
    } else {
        [UIView animateWithDuration:[self objects].keyboardAnimationDutation animations: ^{
            
            [self objects].observerView.frame = [self objects].originalViewFrame;
          
           
        } completion:^(BOOL finished) {
            [self objects].shiftHeight = 0;
        }];
    }
}

+ (CGRect)currentKeyboardFrame
{
    return [[self objects].textEffectsWindow convertRect:[self objects].keyboardFrame fromView:nil];
}

+ (CGRect)currentFirstResponderFrame:(UIView *)view
{
    CGRect currentFirstResponderFrame = [[self objects].textEffectsWindow convertRect:view.frame fromView:view.superview];
    currentFirstResponderFrame.origin.y += [self objects].shiftHeight;
    return currentFirstResponderFrame;
}

@end
