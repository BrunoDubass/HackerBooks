//
//  BDBLibraryTableViewCell.m
//  HackerBooks
//
//  Created by Bruno Domínguez on 25/03/15.
//  Copyright (c) 2015 brunodominguez. All rights reserved.
//

#import "BDBLibraryTableViewCell.h"

@implementation BDBLibraryTableViewCell

+(NSString*)cellId{
    return NSStringFromClass(self);
}
+(CGFloat)cellHigh{
    return 86.0f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
