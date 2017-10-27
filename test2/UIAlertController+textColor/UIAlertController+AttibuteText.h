//
//  UIAlertController+AttibuteText.h
//
//  Created by sunwf on 2017/4/24.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (AttibuteText)

@property (nonatomic,copy) NSMutableAttributedString * attributeTextTitle;//标题富文本
@property (nonatomic,copy) NSMutableAttributedString * attributeTextMessage;//内容富文本

@end


@interface UIAlertAction(_titleColor)

@property (nonatomic,strong) UIColor * titleColor;//title 颜色
//  detaiMessage 这个属性用语实现自定义actionSheet样式，只有不为空时生效,且最后一个action 为cancel style
@property (nonatomic,strong) NSString * detaiMessage;

@end
