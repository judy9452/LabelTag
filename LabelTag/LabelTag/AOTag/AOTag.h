//
//  AOTag.h
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


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, showType){
    horizontalScroll = 0,    //水平滚动
    verticalScroll = 1,      //垂直滚动
};

@class AOTag;

@protocol AOTagDelegate <NSObject>

@optional
- (void)tagDistantImageDidLoad:(AOTag *)tag;
- (void)tagDistantImageDidFailLoad:(AOTag *)tag withError:(NSError *)error;

- (void)tagDidAddTag:(AOTag *)tag;
- (void)tagDidRemoveTag:(AOTag *)tag;
- (void)tagDidSelectTag:(AOTag *)tag;

@end

@interface AOTagList : UIView

@property (nonatomic, weak) id <AOTagDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) UIScrollView   *scrollView;

@property (nonatomic, assign) showType          type;

/**
 * init tags
 * @params frame the CGRect tag frame
 * @params type the showType tagView showType.Default is horizontalScroll.
 */

- (id)initWithFrame:(CGRect)frame showType:(showType)type;

/**
 * Define tag font name and font size.
 *
 * @param name the NSString font name. Default is @"Helvetica-Light".
 * @param size the NSString font size. Default is 12.0f.
 */
- (void)setTagFont:(NSString *)name withSize:(CGFloat)size;

/**************************
 * Methods to load tags with bundle images
 **************************/

/**
 * Create a new tag object
 *
 * @param tTitle the NSString tag label
 * @param tImage the NSString tag image named
 */
- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage;

/**
 * Create a new tag object with custom colors
 *
 * @param tTitle the NSString tag label
 * @param tImage the NSString tag image named
 * @param labelColor the UIColor tag label color. Default color is [UIColor whiteColor]
 * @param backgroundColor the UIColor tag background color. Default color is [UIColor colorWithRed:0.204 green:0.588 blue:0.855 alpha:1.000]
 * @param closeColor the UIColor tag close button color. Default color is [UIColor colorWithRed:0.710 green:0.867 blue:0.953 alpha:1.000]
 */
- (void)addTag:(NSString *)tTitle withImage:(NSString *)tImage withLabelColor:(UIColor *)labelColor withBackgroundColor:(UIColor *)backgroundColor withCloseButtonColor:(UIColor *)closeColor;

/**************************
 * Methods to load tags with distant images
 **************************/

/**
 * Create a new tag object
 *
 * @param tTitle the NSString tag label
 * @param imageURL the NSURL tag image
 * @param tPlaceholderImage the NSString tag image placeholder. If nil no image will be shown will downloading distant image
 */
- (void)addTag:(NSString *)tTitle withImageURL:(NSURL *)imageURL andImagePlaceholder:(NSString *)tPlaceholderImage;

/**
 * Create a new tag object with custom colors
 *
 * @param tTitle the NSString tag label
 * @param tPlaceholderImage the NSString tag image placeholder. If nil no image will be shown will downloading distant image
 * @param imageURL the NSURL tag image
 * @param labelColor the UIColor tag label color. Default color is [UIColor whiteColor]
 * @param backgroundColor the UIColor tag background color. Default color is [UIColor colorWithRed:0.204 green:0.588 blue:0.855 alpha:1.000]
 * @param closeColor the UIColor tag close button color. Default color is [UIColor colorWithRed:0.710 green:0.867 blue:0.953 alpha:1.000]
 */
- (void)addTag:(NSString *)tTitle withImagePlaceholder:(NSString *)tPlaceholderImage withImageURL:(NSURL *)imageURL withLabelColor:(UIColor *)labelColor withBackgroundColor:(UIColor *)backgroundColor withCloseButtonColor:(UIColor *)closeColor;

/**************************
 * Common methods for tags
 **************************/

/**
 * Create a new tags object and add them to the tag list view.
 *
 * @param tags the NSArray tag list to be added. The given tag must be of NSDictionary type (ie. @{@"title": @"Tyrion", @"image": @"tyrion.jpg"})
 */
- (void)addTags:(NSArray *)tags;

/**
 * Remove the given tag from the tag list view
 *
 * @param tag the AOTag instance to be removed
 */
- (void)removeTag:(AOTag *)tag;

/**
 * Remove all tags object
 */
- (void)removeAllTag;

@end

@interface AOTag : UIView

@property (nonatomic, weak) id <AOTagDelegate> delegate;

@property (nonatomic, strong) NSNumber *tFontSize;
@property (nonatomic, strong) NSString *tFontName;

@property (nonatomic, strong) UIColor *tLabelColor;
@property (nonatomic, strong) UIColor *tBackgroundColor;
@property (nonatomic, strong) UIColor *tCloseButtonColor;

@property (nonatomic, strong) UIImage *tImage;
@property (nonatomic, copy) NSString *tTitle;
@property (nonatomic, strong) NSURL *tURL;

/**
 * Return a tag object size
 *
 * @return return a tag object CGSize size
 */
- (CGSize)getTagSize;

@end

@interface AOTagCloseButton : UIView

@property (nonatomic, strong) UIColor *cColor;

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color;

@end
