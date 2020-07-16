//
//  UIView+YHSize.m
//  Pods-YHSegmentViewExample
//
//  Created by Vanha on 2020/7/11.
//

#import "UIView+YHSize.h"

@implementation UIView (YHSize)

- (void)setSize:(CGSize)size;
{
  CGPoint origin = [self frame].origin;
  
  [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGSize)size;
{
  return [self frame].size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left;
{
  return CGRectGetMinX([self frame]);
}

- (void)setLeft:(CGFloat)x;
{
  CGRect frame = [self frame];
  frame.origin.x = x;
  [self setFrame:frame];
}

- (CGFloat)top;
{
  return CGRectGetMinY([self frame]);
}

- (void)setTop:(CGFloat)y;
{
  CGRect frame = [self frame];
  frame.origin.y = y;
  [self setFrame:frame];
}

- (CGFloat)right;
{
  return CGRectGetMaxX([self frame]);
}

- (void)setRight:(CGFloat)right;
{
  CGRect frame = [self frame];
  frame.origin.x = right - frame.size.width;
  
  [self setFrame:frame];
}

- (CGFloat)bottom;
{
  return CGRectGetMaxY([self frame]);
}

- (void)setBottom:(CGFloat)bottom;
{
  CGRect frame = [self frame];
  frame.origin.y = bottom - frame.size.height;

  [self setFrame:frame];
}

- (CGFloat)centerX;
{
  return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
  [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerY;
{
  return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY;
{
  [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGFloat)width;
{
  return CGRectGetWidth([self frame]);
}

- (void)setWidth:(CGFloat)width;
{
  CGRect frame = [self frame];
  frame.size.width = width;

  [self setFrame:CGRectStandardize(frame)];
}

- (CGFloat)height;
{
  return CGRectGetHeight([self frame]);
}

- (void)setHeight:(CGFloat)height;
{
  CGRect frame = [self frame];
  frame.size.height = height;
    
  [self setFrame:CGRectStandardize(frame)];
}


// bounds accessors

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}


// content getters

- (CGRect)contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter
{
    return CGPointMake(self.boundsWidth/2.0f, self.boundsHeight/2.0f);
}

- (void)setLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}


@end
