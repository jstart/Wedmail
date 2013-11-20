//
//  CLTAddressCell.h
//  Wedmail
//
//  Created by Christopher Truman on 11/19/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RHAddressBook/RHPerson.h>

@interface CLTAddressCell : UITableViewCell

-(void)configureWithPerson:(RHPerson *)person;

@end
