//
//  BDBLibraryTableViewCell.h
//  HackerBooks
//
//  Created by Bruno Domínguez on 25/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBLibraryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;



+(NSString*)cellId;
+(CGFloat)cellHigh;

@end
