//
//  UIAlertController+AttibuteText.m
//
//  Created by sunwf on 2017/4/24.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import "UIAlertController+AttibuteText.h"
#import <objc/runtime.h>

//ROW HEIGHT 57  DISTANCE 9


@implementation UIAlertController (AttibuteText)

void _alert_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load{
    [super load];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alert_swizzleMethod([self class], @selector(viewWillAppear:), @selector(setMyCustomView));
    });
}


#pragma mark- Set AttributeTextTitle 

const void * attributeTextTitleKey = @"attributeTextTitleKey";

-(void)setAttributeTextTitle:(NSMutableAttributedString *)attributeTextTitle
{
    objc_setAssociatedObject(self, attributeTextTitleKey, attributeTextTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self setValue:attributeTextTitle forKey:@"_attributedTitle"];
    
}


-(NSMutableAttributedString *)attributeTextTitle
{
    return objc_getAssociatedObject(self, attributeTextTitleKey);
}



#pragma mark- Set AttributeTextMessage

const void * attributeTextMessageKey = @"attributeTextMessageKey";

-(void)setAttributeTextMessage:(NSMutableAttributedString *)attributeTextMessage
{
    objc_setAssociatedObject(self, attributeTextMessageKey, attributeTextMessage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self setValue:attributeTextMessage forKey:@"_attributedMessage"];
    
}


-(NSMutableAttributedString *)attributeTextMessage
{
    return objc_getAssociatedObject(self, attributeTextMessageKey);
}


#pragma mark- Private

-(void)setMyCustomView
{
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        
        UIAlertAction * lastAction = [self.actions lastObject];
        if (lastAction.style == UIAlertActionStyleCancel) {
            
            for (int i=0 ; i< self.actions.count ;i++) {
                
                UIAlertAction * action = self.actions[i];
                if (action.detaiMessage) {
                  
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.4){
                        UIView  * view = [self getCustomActionSheetViewWithIndex:i action:action];
                        
                        view.userInteractionEnabled = NO;
                        [self.view addSubview:  view];
                        
                        
                        
                        UIView * _view = [self valueForKey:@"_view"];
                        NSArray * _actionViews = [_view valueForKey:@"_actionViews"];
                        UIView * theView = _actionViews[i];
                        UILabel * theLab = [theView valueForKey:@"label"];
                        theLab.text = @"";
                        theLab.hidden = YES;
                    }
                    
                    
                }
                
            }
            
        }
        

    }
    
}

-(UIView * )getCustomActionSheetViewWithIndex:(int)index action:(UIAlertAction*)action
{
    UIView * view = [[UIView alloc]init];
    
    CGFloat rowHeight = [[[UIDevice currentDevice] systemVersion] floatValue] >= 9 ? 57 :47;
//    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(0, rowHeight*index, self.view.bounds.size.width-18, rowHeight);
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = action.titleColor;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 5, view.frame.size.width, 20);
    [view addSubview:titleLabel];
    titleLabel.text = action.title;
    
    UILabel * detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = action.titleColor;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.frame = CGRectMake(0, 25, view.frame.size.width, view.frame.size.height-30);
    [view addSubview:detailLabel];
    detailLabel.text = action.detaiMessage;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <9){
        view.frame = CGRectMake(0, rowHeight*index, self.view.bounds.size.width-18, rowHeight);
        titleLabel.frame = CGRectMake(0, 5, view.frame.size.width, 20);
        detailLabel.frame = CGRectMake(0, 25, view.frame.size.width, view.frame.size.height-30);
        titleLabel.font = [UIFont systemFontOfSize:17];
        detailLabel.font =  [UIFont systemFontOfSize:10];

        
    }else  if ([[[UIDevice currentDevice] systemVersion] floatValue] <10){
        view.frame = CGRectMake(0, rowHeight*index, self.view.bounds.size.width, rowHeight);
        titleLabel.frame = CGRectMake(0, 7, view.frame.size.width, 20);
        detailLabel.frame = CGRectMake(0, 27, view.frame.size.width, view.frame.size.height-30);
        titleLabel.font = [UIFont systemFontOfSize:20];
        detailLabel.font =  [UIFont systemFontOfSize:15];


    }else {
        
        view.frame = CGRectMake(0, rowHeight*index, self.view.bounds.size.width-18, rowHeight);
        titleLabel.frame = CGRectMake(0, 7, view.frame.size.width, 20);
        detailLabel.frame = CGRectMake(0, 27, view.frame.size.width, view.frame.size.height-30);
        titleLabel.font = [UIFont systemFontOfSize:20];
        detailLabel.font =  [UIFont systemFontOfSize:15];
    }
    
    
    
    return view;
}




@end


//---------------------------------------------------------------------------------------------------------------------

@implementation UIAlertAction(_titleColor)

#pragma mark- Set Title Color

const void * titleColorKey = @"titleColorKey";
const void * detailMessageKey = @"detailMessageKey";


-(void)setTitleColor:(UIColor *)titleColor
{
    objc_setAssociatedObject(self, titleColorKey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.4){
        [self setValue:titleColor forKey:@"_titleTextColor"];

    }

}

-(UIColor *)titleColor
{
    return objc_getAssociatedObject(self, titleColorKey);
}


-(void)setDetaiMessage:(NSString *)detaiMessage
{
    objc_setAssociatedObject(self, detailMessageKey, detaiMessage , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)detaiMessage
{
    return objc_getAssociatedObject(self, detailMessageKey);
}

@end


