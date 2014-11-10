//
//  DetailViewController.m
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name.text = self.student.name;
    self.describe.text = [NSString stringWithFormat:@"number:(%d) room:(%@)",self.student.number,self.student.room];
    self.imageView.image = [UIImage imageNamed:@"images-2.jpeg"];

    [self animateOnEntry];
}

- (void) animateOnEntry
{
    //set initial frames
    self.backgroundImageView.alpha = 0;
    self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.name.frame.size.height + self.describe.frame.size.height);
    self.name.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.name.frame.size.width, self.name.frame.size.height);
    self.describe.frame = CGRectMake(70, self.name.frame.origin.y + self.name.frame.size.height, self.describe.frame.size.width, self.describe.frame.size.height);
    self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, 50, 50);
    self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
    self.textviewForDetail.alpha = 0;
    self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
    
    //apply animation on ENTERING INTO THE VIEW
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.name.frame = CGRectMake(35, 180, self.name.frame.size.width, self.name.frame.size.height);
         self.describe.frame = CGRectMake(35, 250, self.describe.frame.size.width, self.describe.frame.size.height);
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
         self.backgroundImageView.alpha = 1;
         
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.view.frame.size.height - self.textviewForDetail.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 1;
         
         NSLog(@"width %f height %f",self.imageView.frame.size.width,self.imageView.frame.size.height);
         
         self.imageView.frame = CGRectMake(110, 50, self.imageView.frame.size.width * 2, self.imageView.frame.size.height * 2);
     }
                     completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnPressed:(id)sender
{
    //animation on EXIT FROM CURRENT VIEW
    [UIView animateWithDuration:0.4f animations:^
     {
         self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.name.frame.size.height + self.describe.frame.size.height);
         self.name.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.name.frame.size.width, self.name.frame.size.height);
         self.describe.frame = CGRectMake(70, self.name.frame.origin.y + self.name.frame.size.height, self.describe.frame.size.width, self.describe.frame.size.height);
         self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, CGRectGetWidth(self.imageView.frame) / 2, CGRectGetHeight(self.imageView.frame) / 2);
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 0;
         self.backgroundImageView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self.navigationController popViewControllerAnimated:NO];
     }
     ];
}

@end
