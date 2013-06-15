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
    NSArray *tmpStoreGRs; // Hold on to gestures when not being used
    GLfloat storedy; // Keeps track of view location when scrolling
    float keyboardHeight; // The keyboard height
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Register for notifications from keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDismiss) name:UIKeyboardDidHideNotification object:nil];
    
}

/**
 * Called when the keyboard becomes active
 */
- (void)keyboardDidShow:(NSNotification *)notification
{
    // Hold onto any gestures you had on your view
    tmpStoreGRs = self.view.gestureRecognizers;
    // Get the current height of the server
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height -
                        [UIApplication sharedApplication].statusBarFrame.size.height;
    // Set up usefull gestures for moving the view around and closing it.
    UIPanGestureRecognizer *scrollViewForKeyboard = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollView:)];
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(keyboardDidDismiss)];
    // Setting only the gestures you need for navigation on the view
    [self.view setGestureRecognizers:@[scrollViewForKeyboard, dismissKeyboard]];
}

/**
 * Called when the keyboard is dimissed
 */
- (void)keyboardDidDismiss
{
    // Add the previous gestures to the view replacing the keyboard ones
    [self.view setGestureRecognizers:tmpStoreGRs];
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    // Animate view back home.
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:frame];
    }];
    for(UIView *sub in self.view.subviews) {
        [sub resignFirstResponder];
    }
}

/**
 * Used for moving the view objects when the keyboard is visible
 */
- (void)scrollView:(UIPanGestureRecognizer *)reg
{
    switch (reg.state) {
        case UIGestureRecognizerStateBegan:
            // Hold onto the starting point
            storedy = self.view.frame.origin.y;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
            CGRect frame = self.view.frame;
            // Updated the frame with translation data
            frame.origin.y = storedy + [reg translationInView:[UIApplication sharedApplication].keyWindow].y;
            // Bound checking to keep view on screen
            if (frame.origin.y > navHeight)
                frame.origin.y = navHeight;
            if (frame.origin.y < - keyboardHeight + navHeight)
                frame.origin.y = - keyboardHeight + navHeight;
            // Move the view
            [self.view setFrame:frame];
            
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Do the talking
 */
- (IBAction)talk:(id)sender
{
    AVSpeechSynthesizer *talker = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *sayit = [AVSpeechUtterance speechUtteranceWithString:_input.text];
    [talker speakUtterance:sayit];
}

@end
