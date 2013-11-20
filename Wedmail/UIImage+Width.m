//
//  UIImage+Width.m
//  Wedmail
//
//  Created by Christopher Truman on 11/3/13.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "UIImage+Width.h"

@implementation UIImage (Width)
-(UIImage*)imageScaledToWidth: (float) i_width
{
    float oldWidth = self.size.width;
    float scaleFactor = i_width / oldWidth;

    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), YES, 2.5);
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
