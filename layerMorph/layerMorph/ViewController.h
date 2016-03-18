//
//  ViewController.h
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(u_int8_t, SHAPE_TYPE) {
    SHAPE_TYPE_CIRCLE = 0,
    SHAPE_TYPE_SQUARE = 1,
    SHAPE_TYPE_TRIANGLE = 2,
    SHAPE_TYPE_PLUS = 3,
    SHAPE_TYPE_MAX = 4
};

@interface ViewController : UIViewController
{
    SHAPE_TYPE currentShape;
    CGPoint shapeCenter;
    CGFloat shapeRadius;
    UIColor *shapeColor;
    CAShapeLayer *shapeLayer;
    bool animating;
    int squareStartingIndex;
}

@end

