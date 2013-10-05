//
//  ViewController.m
//  RD_ImageMasking
//
//  Created by Mevan Alles on 5/10/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "ViewController.h"

static const CGSize maskShapeSize = { 40, 40 };

@interface ViewController ()

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation ViewController

static UIImage *__maskImage;
- (CALayer *)maskLayer
{
    if (!__maskImage)
    {
        _maskLayer = [CALayer layer];
        _maskLayer.frame = (CGRect){ 0, 0, maskShapeSize.width, maskShapeSize.height };
        
        UIGraphicsBeginImageContextWithOptions(maskShapeSize, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        CGContextSaveGState(context);
        {
            UIColor *backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            
            UIBezierPath* bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, maskShapeSize.width, maskShapeSize.height)];

            [backgroundColor setFill];
            [bezierPath fill];

            __maskImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        CGContextRestoreGState(context);

        
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
        
        _maskLayer.contents = (__bridge id)(__maskImage.CGImage);
    }
    return _maskLayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bottomView.hidden = YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.bottomView.layer.mask = self.maskLayer;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.topImageView];
    
    self.maskLayer.position = currentPoint;
    
    self.bottomView.hidden = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.topImageView];
    
    self.maskLayer.position = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.bottomView.layer.mask = Nil;
    self.bottomView.hidden = YES;

}

@end
