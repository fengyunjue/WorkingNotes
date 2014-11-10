//
//  DetailViewController.h
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

#define MAIN_LABEL_Y_ORIGIN 0
#define IMAGEVIEW_Y_ORIGIN 15

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *describe;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UITextView *textviewForDetail;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (readwrite, nonatomic) int yOrigin;
@property (strong, nonatomic) Student *student;

- (IBAction)doneBtnPressed:(id)sender;
@end
