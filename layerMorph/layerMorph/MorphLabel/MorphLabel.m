//
//  MorphLabel.m
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "MorphLabel.h"

@implementation MorphLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        textLayer = [[CAShapeLayer alloc] init];
        textLayer.frame = self.bounds;
        [textLayer setMasksToBounds:YES];
        [self.layer setMask:textLayer];
        labelColor = [UIColor magentaColor];
        [self setText:@" "];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (void)setColor:(UIColor*)color
{
    labelColor = color;
}

- (void)setText:(NSString*)newText
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [textLabel setText:newText];
    [textLabel setTextColor:[UIColor blackColor]];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:28]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    UIImage *layerMaskImage = [self imageFromView:textLabel];
    [UIView animateWithDuration:0.72 animations:^{
        [self setBackgroundColor:labelColor];\
        self.layer.mask.contents = (id)[layerMaskImage CGImage];
    }];
}

- (UIImage*)imageFromView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO,2);
    //CGAffineTransform verticalFlip = CGAffineTransformMake(1, 0, 0, -1, 0, view.frame.size.height);
    //CGContextConcatCTM(UIGraphicsGetCurrentContext(), verticalFlip);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
