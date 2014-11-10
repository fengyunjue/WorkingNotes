//
//  ClientCell.h
//  PersonalTraining
//
//
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface SampleCell : UITableViewCell {
    
}

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *describe;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@end
