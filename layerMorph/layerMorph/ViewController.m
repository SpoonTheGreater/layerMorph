//
//  ViewController.m
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createShape];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeShape)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createShape
{
    shapeCenter = (CGPoint){self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5};
    shapeRadius = (self.view.bounds.size.width > self.view.bounds.size.height)?self.view.bounds.size.height*0.2:self.view.bounds.size.width*0.2;
    shapeColor = [UIColor colorWithHue:(arc4random()%10)/10.0 saturation:1.0 brightness:1.0 alpha:1.0];
    currentShape = (arc4random()%2==0)?SHAPE_TYPE_CIRCLE:SHAPE_TYPE_SQUARE;
    shapeLayer = (currentShape==SHAPE_TYPE_CIRCLE)?[self getCircle]:[self getSquare];
    [[self.view layer] addSublayer:shapeLayer];
}

- (CAShapeLayer*)getSquare
{
    CAShapeLayer *square = [[CAShapeLayer alloc] init];
    UIBezierPath *squarePath = [[UIBezierPath alloc] init];
    
    [squarePath moveToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y - shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y + shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y + shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y - shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y - shapeRadius}];
    
    square.path = squarePath.CGPath;
    square.strokeColor = shapeColor.CGColor;
    square.fillColor = shapeColor.CGColor;
    square.lineWidth = 1;
    
    return square;
}



- (CAShapeLayer*)getCircle
{
    CAShapeLayer *circle = [[CAShapeLayer alloc] init];
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    [circlePath addArcWithCenter:shapeCenter radius:shapeRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circle.path = circlePath.CGPath;
    circle.strokeColor = shapeColor.CGColor;
    circle.fillColor = shapeColor.CGColor;
    circle.lineWidth = 1;
    
    return circle;
}

- (void)changeShape
{
    if ( animating )
        return;
    animating = YES;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.73];//1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    CAShapeLayer *newLayer = (currentShape==SHAPE_TYPE_SQUARE)?[self getCircle]:[self getSquare];
    currentShape = (currentShape==SHAPE_TYPE_SQUARE)?SHAPE_TYPE_CIRCLE:SHAPE_TYPE_SQUARE;
    shapeColor = [UIColor colorWithHue:(arc4random()%10)/10.0 saturation:1.0 brightness:1.0 alpha:1.0];
    
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [shapeLayer setFillColor:shapeColor.CGColor];
        [shapeLayer setPath:newLayer.path];
        [shapeLayer setStrokeColor:shapeColor.CGColor];
        [CATransaction commit];
        animating = NO;
    }];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //pathAnimation.duration = 2;
    pathAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.path);
    pathAnimation.toValue = (__bridge id _Nullable)(newLayer.path);
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.cumulative = YES;
    [shapeLayer addAnimation:pathAnimation forKey:@"path"];
   
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    //fillColorAnimation.duration = 2;
    
    fillColorAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.fillColor);
    fillColorAnimation.toValue = (__bridge id _Nullable)(shapeColor.CGColor);
    fillColorAnimation.removedOnCompletion = NO;
    fillColorAnimation.cumulative = YES;
    [shapeLayer addAnimation:fillColorAnimation forKey:@"fillColor"];
    
    CABasicAnimation *strokeColorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    //strokeColorAnimation.duration = 2;
    
    strokeColorAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.fillColor);
    strokeColorAnimation.toValue = (__bridge id _Nullable)(shapeColor.CGColor);
    strokeColorAnimation.removedOnCompletion = NO;
    strokeColorAnimation.cumulative = YES;
    [shapeLayer addAnimation:strokeColorAnimation forKey:@"strokeColor"];
    
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void (^animationCompletionBlock)(void) = [anim valueForKey:@"animationCompletionBlock"];
    if (animationCompletionBlock)
        animationCompletionBlock();
    [shapeLayer removeAllAnimations];
}
@end
