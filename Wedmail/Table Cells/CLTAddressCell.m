//
//  CLTAddressCell.m
//  Wedmail
//
//  Created by Christopher Truman on 11/19/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTAddressCell.h"

@interface CLTAddressCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation CLTAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)configureWithPerson:(RHPerson *)person{
    [self.profileImageView setImage:person.thumbnail];

    NSString * nameText = person.compositeName;

    [self.nameLabel setText:nameText];

    NSString * city = [person.addresses valueAtIndex:0][@"City"];
    NSString * country = [person.addresses valueAtIndex:0][@"Country"];
    NSString * state = [person.addresses valueAtIndex:0][@"State"];
    NSString * street = [person.addresses valueAtIndex:0][@"Street"];
    NSString * zip = [person.addresses valueAtIndex:0][@"ZIP"];
    NSString * addressLabelText = nil;
    if (country && zip) {
        addressLabelText = [NSString stringWithFormat:@"%@\n%@, %@, %@, %@", street, city, state, zip, country];
    }else if(zip && country == nil){
        addressLabelText = [NSString stringWithFormat:@"%@\n%@, %@, %@", street, city, state, zip];
    }else if(zip == nil  && country){
        addressLabelText = [NSString stringWithFormat:@"%@\n%@, %@, %@", street, city, state, country];
    }else{
        addressLabelText = [NSString stringWithFormat:@"%@\n%@, %@", street, city, state];
    }
    
    [self.addressLabel setText:addressLabelText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
