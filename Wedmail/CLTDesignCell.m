//
//  CLTDesignCell.m
//  Wedmail
//
//  Created by Christopher Truman on 11/3/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTDesignCell.h"

@interface CLTDesignCell ()

@end

@implementation CLTDesignCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.designImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 181)];
        [self addSubview:self.designImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [self.designImageView setAlpha:0.8];
    }else{
        [self.designImageView setAlpha:1.0];
    }
}

@end
