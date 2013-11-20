//
//  UIView+Rasterize.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/5/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "UIView+Rasterize.h"

@implementation UIView (Rasterize)

+(UIImage*) rasterizeView: (UIView*) view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);

    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //now that we are done we return this image back,
    return viewImage;
}

+(UIImage*) rasterizeView: (UIView*) view andView:(UIView *)otherView
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [otherView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //now that we are done we return this image back,
    return viewImage;
}

@end
