//
//  RELongTextCell.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 4/11/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RETableViewLongTextCell.h"
#import "RETableViewManager.h"

@implementation RETableViewLongTextCell

+ (BOOL)canFocus
{
    return YES;
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    _textView = [[REPlaceholderTextView alloc] initWithFrame:CGRectNull];
    
    _textView.inputAccessoryView = self.actionBar;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [self addSubview:_textView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [_textView becomeFirstResponder];
    }
}

- (void)cellWillAppear
{
    [super cellWillAppear];

    _textView.text = self.item.value;
    _textView.placeholder = self.item.placeholder;
    _textView.placeholderColor = self.item.placeholderColor;
    _textView.font = self.tableViewManager.style.textFieldFont;
    _textView.autocapitalizationType = self.item.autocapitalizationType;
    _textView.autocorrectionType = self.item.autocorrectionType;
    _textView.spellCheckingType = self.item.spellCheckingType;
    _textView.keyboardType = self.item.keyboardType;
    _textView.keyboardAppearance = self.item.keyboardAppearance;
    _textView.returnKeyType = self.item.returnKeyType;
    _textView.enablesReturnKeyAutomatically = self.item.enablesReturnKeyAutomatically;
    _textView.secureTextEntry = self.item.secureTextEntry;
}

- (UIResponder *)responder
{
    return _textView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 20 : 60;
    CGRect frame = CGRectMake(0, self.tableViewManager.style.textFieldPositionOffset.height + 4, 0, self.frame.size.height - self.tableViewManager.style.textFieldPositionOffset.height - 8);
    frame.origin.x = cellOffset + self.tableViewManager.style.textFieldPositionOffset.width - 8;
    frame.size.width = self.frame.size.width - frame.origin.x - cellOffset + 8;
    _textView.frame = frame;
}


#pragma mark -
#pragma mark UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self updateActionBarNavigationControl];
    [self.parentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:self.sectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.item.value = textView.text;
}

@end
