//
//  AOTag.m
//  AOTagDemo
//
//  Created by Loïc GRIFFIE on 16/09/13.
//  Copyright (c) 2013 Appsido. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AOTag.h"

#define tagFontSize         13.0f
#define tagFontType         @"Helvetica-Light"
#define tagMargin           10.0f
#define tagHeight           30.0f
#define tagCornerRadius     3.0f
#define tagCloseButton      7.0f
#define UICOLOR_RGBA(R,G,B,A)       ([UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)])
#define ScreenWidth                 ([UIScreen mainScreen].bounds.size.width)

@interface AOTagList ()

@property (nonatomic, strong) NSNumber *tFontSize;
@property (nonatomic, strong) NSString *tFontName;

@end

@implementation AOTagList

- (id)initWithFrame:(CGRect)frame showType:(showType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        self.tags = [NSMutableArray array];
        self.type = type;
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.scrollView];

        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.type == horizontalScroll) {
        //水平滚动
        int n = 0;
        float x = 15.0f;
        float y = 7.5f;
        
            //重新绘制所有的tag
        for (id v in [self.scrollView subviews])
            if ([v isKindOfClass:[AOTag class]])
                [v removeFromSuperview];
        
        for (AOTag *tag in self.tags)
        {
            x += (n ? tagMargin : 0.0f);
            if (x + [tag getTagSize].width + tagMargin > self.frame.size.width){
                self.scrollView.contentOffset = CGPointMake(x + [tag getTagSize].width + tagMargin, 0);
            }
            
            [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
            [self.scrollView addSubview:tag];
            
            x += [tag getTagSize].width;
            n++;
            
        }
        
        self.scrollView.contentSize = CGSizeMake(x+tagMargin, 45);
        [self.scrollView setNeedsLayout];
    }else{
        //垂直滚动
        int n = 0;
        float x = 15.0f;
        float y = 7.5f;
        float contentSizeHeight = 0.0f;
        
        for (id v in [self.scrollView subviews])
            if ([v isKindOfClass:[AOTag class]])
                [v removeFromSuperview];
        
        for (AOTag *tag in self.tags)
        {
            if (x + [tag getTagSize].width + tagMargin > self.frame.size.width) {
                    //换行
                n = 0; x = 15.0; y += [tag getTagSize].height + tagMargin;
                    //设置scrollview的偏移量
                self.scrollView.contentOffset = CGPointMake(0, y-tagMargin);
                    //记录可滚动区域大小
                contentSizeHeight = y+tagMargin+[tag getTagSize].height;
            }else x += (n ? tagMargin : 0.0f);
            
            [tag setFrame:CGRectMake(x, y, [tag getTagSize].width, [tag getTagSize].height)];
            [self.scrollView addSubview:tag];
            
            x += [tag getTagSize].width;
            n++;
        }
        
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, contentSizeHeight);
        [self.scrollView setNeedsLayout];
        
    }
}

- (void)setTagFont:(NSString *)name withSize:(CGFloat)size
{
    [self setTFontSize:[NSNumber numberWithFloat:size]];
    [self setTFontName:name];
}

- (AOTag *)generateTagWithLabel:(NSString *)tTitle withImage:(NSString *)tImage
{
    AOTag *tag = [[AOTag alloc] initWithFrame:CGRectZero];
    
    [tag setTFontName:self.tFontName];
    [tag setTFontSize:self.tFontSize];
    
    [tag setDelegate:self.delegate];
    [tag setTImage:[UIImage imageNamed:tImage]];
    [tag setTTitle:tTitle];
    
    [self.tags addObject:tag];
    
    return tag;
}

- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage
{
    [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle withImageURL:(NSURL *)imageURL andImagePlaceholder:(NSString *)tPlaceholderImage
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    [tag setTURL:imageURL];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
     withImage:(NSString *)tImage
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tImage ? tImage : @"")];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
}

- (void)addTag:(NSString *)tTitle
withImagePlaceholder:(NSString *)tPlaceholderImage
  withImageURL:(NSURL *)imageURL
withLabelColor:(UIColor *)labelColor
withBackgroundColor:(UIColor *)backgroundColor
withCloseButtonColor:(UIColor *)closeColor
{
    AOTag *tag = [self generateTagWithLabel:(tTitle ? tTitle : @"") withImage:(tPlaceholderImage ? tPlaceholderImage : @"")];
    
    [tag setTURL:imageURL];
    
    if (labelColor) [tag setTLabelColor:labelColor];
    if (backgroundColor) [tag setTBackgroundColor:backgroundColor];
    if (closeColor) [tag setTCloseButtonColor:closeColor];
    
    [self setNeedsDisplay];
}

- (void)addTags:(NSArray *)tags
{
    for (NSDictionary *tag in tags)
        [self addTag:[tag objectForKey:@"title"] withImage:[tag objectForKey:@"image"]];
}

- (void)removeTag:(AOTag *)tag
{
    [self.tags removeObject:tag];
    
    [self setNeedsDisplay];
}

- (void)removeAllTag
{
    for (id t in [NSArray arrayWithArray:[self tags]])
        [self removeTag:t];
}

@end

@implementation AOTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tBackgroundColor = [UIColor colorWithRed:0.204 green:0.588 blue:0.855 alpha:1.000];
        self.tLabelColor = [UIColor whiteColor];
        self.tCloseButtonColor = [UIColor colorWithRed:0.710 green:0.867 blue:0.953 alpha:1.000];
        
        self.tFontSize = [NSNumber numberWithFloat:tagFontSize];
        self.tFontName = tagFontType;
        
        self.tURL = nil;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [[self layer] setCornerRadius:tagCornerRadius];
        [[self layer] setMasksToBounds:YES];
        
    }
    return self;
}

- (CGSize)getTagSize
{
    CGSize tSize = [self.tTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]}];
    
    
    return CGSizeMake(tagHeight + tagMargin + tSize.width + tagMargin, tagHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
        //自定义tag的样式
    self.layer.backgroundColor = [self.tBackgroundColor CGColor];
        
    CGSize tSize = [self.tTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]]}];
    [self.tTitle drawInRect:CGRectMake(10, ([self getTagSize].height / 2.0f) - (tSize.height / 2.0f), tSize.width, tSize.height)
             withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.tFontName size:[self.tFontSize floatValue]], NSForegroundColorAttributeName:self.tLabelColor}];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(tSize.width+20, 5, 0.5, tagHeight-10)];
    lineView.backgroundColor = UICOLOR_RGBA(255, 255, 255, 0.15);
    [self addSubview:lineView];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(CGRectGetMaxX(lineView.frame), 0, tagHeight, tagHeight);
    [close setImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(tagClose:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:close];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagSelected:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidAddTag:)])
        [self.delegate performSelector:@selector(tagDidAddTag:) withObject:self];
}

- (void)tagSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidSelectTag:)])
        [self.delegate performSelector:@selector(tagDidSelectTag:) withObject:self];
}

- (void)tagClose:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidRemoveTag:)])
        [self.delegate performSelector:@selector(tagDidRemoveTag:) withObject:self];
    UIView *view = [self superview];
    [(AOTagList *)[view superview] removeTag:self];
}


@end

@implementation AOTagCloseButton

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        [self setCColor:color];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [self.cColor setStroke];
    bezierPath.lineWidth = 2.0;
    [bezierPath stroke];
    
    UIBezierPath *bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint:CGPointMake(rect.size.width - tagCloseButton + 1.0, ((rect.size.height - tagCloseButton) / 2.0) + tagCloseButton)];
    [bezier2Path addLineToPoint:CGPointMake(rect.size.width - (tagCloseButton * 2.0) + 1.0, (rect.size.height - tagCloseButton) / 2.0)];
    [self.cColor setStroke];
    bezier2Path.lineWidth = 2.0;
    [bezier2Path stroke];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClose:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)tagClose:(id)sender
{
    if ([[self superview] respondsToSelector:@selector(tagClose:)])
        [[self superview] performSelector:@selector(tagClose:) withObject:self];
}

@end
