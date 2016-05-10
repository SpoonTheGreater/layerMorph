//
//  MorphLabel.h
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorphLabel : UIView
{
    NSString *text;
    UIColor *labelColor;
    CAShapeLayer *textLayer;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setText:(NSString*)newText;
- (void)setColor:(UIColor*)color;

@end
