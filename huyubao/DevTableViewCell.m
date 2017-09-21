//
//  DevTableViewCell.m
//  huyubao
//
//  Created by mao ke on 2017/4/20.
//  Copyright © 2017年 mao ke. All rights reserved.
//

#import "DevTableViewCell.h"

@implementation DevTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_zyj.layer setBorderColor:[UIColor greenColor].CGColor];
    [_zyj.layer setBorderWidth:1];
    [_zyj.layer setMasksToBounds:YES];
    _zyj.layer.cornerRadius = 5.0f;
    _zyj.layer.masksToBounds = YES;
    
    [_autoControl.layer setBorderColor:[UIColor greenColor].CGColor];
    [_autoControl.layer setBorderWidth:1];
    [_autoControl.layer setMasksToBounds:YES];
    _autoControl.layer.cornerRadius = 5.0f;
    _autoControl.layer.masksToBounds = YES;

    // Configure the view for the selected state
}

- (IBAction)switchClick:(id)sender {
}


@end
