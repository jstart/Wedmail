//
//  CLTPerson.m
//  Wedmail
//
//  Created by Christopher Truman on 11/19/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "CLTPerson.h"

@implementation CLTPerson

-(id)initWithABRecordRef:(ABRecordRef)abRecordRef{
    self = [super init];
    if (self) {

        if (!abRecordRef){
            return nil;
        }

        _recordRef = CFRetain(abRecordRef);
    }
    return self;
}

@end
