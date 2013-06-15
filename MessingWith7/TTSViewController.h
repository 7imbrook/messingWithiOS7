//
//  TTSViewController.h
//  MessingWith7
//
//  Created by Michael Timbrook on 6/11/13.
//  Copyright (c) 2013 MichaelTimbrook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSViewController : UIViewController
- (IBAction)talk:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *input;

@end
