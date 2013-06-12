//
//  TTSViewController.m
//  MessingWith7
//
//  Created by Michael Timbrook on 6/11/13.
//  Copyright (c) 2013 MichaelTimbrook. All rights reserved.
//

#import "TTSViewController.h"

@interface TTSViewController ()

@end

@implementation TTSViewController {
    NSArray *tmpStoreGRs;
    GLfloat storedy;
    float keyboardHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Register for notifications from keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDismiss) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    tmpStoreGRs = self.view.gestureRecognizers;
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height -
                        [UIApplication sharedApplication].statusBarFrame.size.height;
    UIPanGestureRecognizer *scrollViewForKeyboard = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollView:)];
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view setGestureRecognizers:@[scrollViewForKeyboard, dismissKeyboard]];
}

- (void)keyboardDidDismiss
{
    [self.view setGestureRecognizers:tmpStoreGRs];
}

- (void)scrollView:(UIPanGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            storedy = self.view.frame.origin.y;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
            CGRect frame = self.view.frame;
            frame.origin.y = storedy + [reg translationInView:[UIApplication sharedApplication].keyWindow].y;
            if (frame.origin.y > navHeight)
                frame.origin.y = navHeight;
            if (frame.origin.y < - keyboardHeight + navHeight)
                frame.origin.y = - keyboardHeight + navHeight;
            
            [self.view setFrame:frame];
            
            break;
        }
        default:
            break;
    }
}

- (void)dismissKeyboard {
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:frame];
    }];
    for(UIView *sub in self.view.subviews) {
        [sub resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
