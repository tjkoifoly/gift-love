//
//  DBSignupViewController.m
//  DBSignup
//
//  Created by Davide Bettio on 7/4/11.
//  Copyright 2011 03081340121. All rights reserved.
//

#import "DBSignupViewController.h"
#import "UserManager.h"
#import "FunctionObject.h"
#import "JSONKit.h"
#import "ShakingAlertView.h"
#import "UIImageView+AFNetworking.h"

// Safe releases
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT            7
#define BIRTHDAY_FIELD_TAG      5
#define GENDER_FIELD_TAG        6
#define EMAIL_FIELD_TAG         3

@implementation DBSignupViewController
{
    BOOL changeAvatar;
}

@synthesize viewMode = _viewMode;
@synthesize nameTextField = nameTextField_;
@synthesize lastNameTextField = lastNameTextField_;
@synthesize emailTextField = emailTextField_;
@synthesize passwordTextField = passwordTextField_;
@synthesize birthdayTextField = birthdayTextField_;
@synthesize genderTextField = genderTextField_;
@synthesize phoneTextField = phoneTextField_;
@synthesize photoButton = photoButton_;
@synthesize termsTextView = termsTextView_;

@synthesize emailLabel = emailLabel_;
@synthesize passwordLabel = passwordLabel_;
@synthesize birthdayLabel = birthdayLabel_;
@synthesize genderLabel = genderLabel_;
@synthesize phoneLabel = phoneLabel_;

@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize genderPickerView = genderPickerView_;
@synthesize birthdayDatePicker = birthdayDatePicker_;

@synthesize birthday = birthday_;
@synthesize gender = gender_;
@synthesize photo = photo_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    changeAvatar = NO;
    // Signup button
    
    switch (_viewMode) {
        case ProfileViewTypeSignUp:
        {
            self.navigationItem.title = @"Sign up";
            UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sign up", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(signup:)];
            self.navigationItem.rightBarButtonItem = signupBarItem;
            self.photo = nil;

        }
            break;
        case ProfileViewTypeEdit:
        {
            self.navigationItem.title = @"Profiles";
            UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveProfiles:)];
            self.navigationItem.rightBarButtonItem = signupBarItem;
            self.lastNameTextField.enabled = NO;
            self.termsTextView.hidden = YES;
            
            //LOAD information
            

        }
            break;
            
        default:
            break;
    }
        
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 54, 34)];
    [btnBack addTarget:self action:@selector(backPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    // Birthday date picker
    if (self.birthdayDatePicker == nil) {
        self.birthdayDatePicker = [[UIDatePicker alloc] init];
        [self.birthdayDatePicker addTarget:self action:@selector(birthdayDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setYear:-18];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
        [self.birthdayDatePicker setDate:selectedDate animated:NO];
        [self.birthdayDatePicker setMaximumDate:currentDate];
    }
    
    // Gender picker
    if (self.genderPickerView == nil) {
        self.genderPickerView = [[UIPickerView alloc] init];
        self.genderPickerView.delegate = self;
        self.genderPickerView.showsSelectionIndicator = YES;
    }
    
    // Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"previous", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        self.nameTextField.inputAccessoryView = self.keyboardToolbar;
        self.lastNameTextField.inputAccessoryView = self.keyboardToolbar;
        self.emailTextField.inputAccessoryView = self.keyboardToolbar;
        self.passwordTextField.inputAccessoryView = self.keyboardToolbar;
        self.birthdayTextField.inputAccessoryView = self.keyboardToolbar;
        self.birthdayTextField.inputView = self.birthdayDatePicker;
        self.genderTextField.inputAccessoryView = self.keyboardToolbar;
        self.genderTextField.inputView = self.genderPickerView;
        self.phoneTextField.inputAccessoryView = self.keyboardToolbar;
        
    }
    
    // Set localization
    self.nameTextField.placeholder = NSLocalizedString(@"Display Name", @"");
    self.lastNameTextField.placeholder = NSLocalizedString(@"User Name", @"");
    self.emailLabel.text = [NSLocalizedString(@"email", @"") uppercaseString]; 
    self.passwordLabel.text = [NSLocalizedString(@"password", @"") uppercaseString];
    self.birthdayLabel.text = [NSLocalizedString(@"birthdate", @"") uppercaseString]; 
    self.genderLabel.text = [NSLocalizedString(@"gender", @"") uppercaseString]; 
    self.phoneLabel.text = [NSLocalizedString(@"phone", @"") uppercaseString];
    self.phoneTextField.placeholder = NSLocalizedString(@"optional", @"");
    self.termsTextView.text = NSLocalizedString(@"terms", @"");
    
    // Reset labels colors
    [self resetLabelsColors];
    if (_viewMode == ProfileViewTypeEdit) {
        [self loadInfo];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
    [self setImvAvatar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"") 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""), NSLocalizedString(@"take_photo_from_library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"") 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
}

- (IBAction)backPreviousView:(id)sender {
    if (_viewMode == ProfileViewTypeSignUp) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.25];
    
}

- (IBAction)signUpPressed:(id)sender {
    [self signup:sender];
}

-(BOOL)checkInput
{
    if ([self.nameTextField.text length] ==0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Display name is not allowed blank!"];
        return NO;
    }
    if ([self.lastNameTextField.text length] < 3) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Username is too short! Please enter 3 characters."];
        return NO;
    }
    if (![self validateUserName:[lastNameTextField_.text lowercaseString]]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Username is not correct format. Only use 'a-z', '0-9', '_', '-' and '.' and begin by a letter, not end by '-' or '.'"];
        return NO;
    }
    
    if(![self NSStringIsValidEmail:emailTextField_.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email is not correct!"];
        return NO;
    }
    if ([self.emailTextField.text length] == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Email is not correct!"];
        return NO;
    }
    if ([passwordTextField_.text length] < 6) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Password is too short! Please enter least 6 characters."];
        return NO;
    }
    if ([self.birthdayTextField.text length] ==0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Birthday is not allowed blank!"];
        return NO;
    }
    if ([self.genderTextField.text length] == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Gender is not allowed blank!"];
        return NO;
    }
    return YES;
}

-(void) saveProfiles: (id) sender
{
    if ([self checkInput]) {
        
        ShakingAlertView *shakingAlert = nil;
        if ([self checkChangePassword]) {
            shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                       checkForPassword:passwordTextField_.text];
        }else{
            shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                      checkForPassword:[[UserManager sharedInstance] password] usingHashingTechnique:HashTechniqueMD5];
        }
        [shakingAlert setOnCorrectPassword:^{
            // Show a modal view
            [self saveWithMethodUsage:@"update_info"];
        }];
        [shakingAlert show];
    }
}

-(void) saveWithMethodUsage: (NSString *)usage
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
	
    NSLog(@"HUD = %@", HUD);
    
    if (changeAvatar) {
        NSData *imgData = UIImagePNGRepresentation(self.photo);
        [self saveInfo:imgData WithProgress:^(CGFloat progress) {
            HUD.mode = MBProgressHUDModeDeterminate;
            HUD.progress = progress;
        } completion:^(BOOL success, NSError *error, NSString *urlUpload) {
            if (success) {
                [self saveInfoWithAvatar:urlUpload usage:usage completion:^(BOOL success, NSError *error) {
                    if (success) {
                        NSString *msgNotif = [usage isEqualToString:@"update_info"]?@"Update successful":@"Sign up successful";
                        NSLog(@"%@", msgNotif);
                        
                        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                        HUD.mode = MBProgressHUDModeCustomView;
                        HUD.labelText = msgNotif;
                        [self autoRememPassword];
                        [self performSelector:@selector(backPreviousView:) withObject:nil afterDelay:0.5];
                    }else
                    {
                        NSLog(@"Update failed! = %@", error);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    
                }];
            }else{
                NSLog(@"Update failed!");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
        
    }else
    {
        [self saveInfoWithAvatar:nil usage:usage completion:^(BOOL success, NSError *error) {
            if (success) {
                NSString *msgNotif = [usage isEqualToString:@"update_info"]?@"Update successful":@"Sign up successful";
                NSLog(@"%@", msgNotif);
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = msgNotif;
                NSLog(@"HUD = %@", HUD);
                
                if ([self checkChangePassword]) {
                    [self autoRememPassword];
                }

                [self performSelector:@selector(backPreviousView:) withObject:nil afterDelay:0.5];
            }else
            {
                NSLog(@"ERROR SIGN UP!= %@", error);
                [HUD hide:YES afterDelay:0.3];
                
            }
           
        }];
        
    }

}

-(void) autoRememPassword
{
    BOOL autoRemember = [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_remember_preference"];
    if(autoRemember)
    {
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password_preference"];
    }
}

#pragma mark - Others

- (void)signup:(id)sender
{
    [self resignKeyboard:nil];
    
    // Check fields
    if ([self checkInput]) {
        ShakingAlertView *shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                                    checkForPassword:passwordTextField_.text];
        [shakingAlert setOnCorrectPassword:^{
            // Show a modal view
            [self saveWithMethodUsage:@"sign_up"];
        }];
        [shakingAlert show];
        
        //[self saveWithMethodUsage:@"sign_up"];
    }
}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors];
    }
}

- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        }
        [self checkSpecialFields:previousTag];
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        }
        [self checkSpecialFields:nextTag];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
    if (tag == BIRTHDAY_FIELD_TAG && [self.birthdayTextField.text isEqualToString:@""]) {
        [self setBirthdayData];
    } else if (tag == GENDER_FIELD_TAG && [self.genderTextField.text isEqualToString:@""]) {
        [self setGenderData];
    }
}

- (void)setBirthdayData
{
    self.birthday = self.birthdayDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.birthdayTextField.text = [dateFormatter stringFromDate:self.birthday];
}
- (void)setBirthdayWithDate: (NSDate *) date
{
    self.birthday = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.birthdayTextField.text = [dateFormatter stringFromDate:self.birthday];
}

- (void)setGenderData
{
    if ([self.genderPickerView selectedRowInComponent:0] == 0) {
        self.genderTextField.text = NSLocalizedString(@"male", @"");
        self.gender = @"M";
    } else {
        self.genderTextField.text = NSLocalizedString(@"female", @"");
        self.gender = @"F";
    }
}
- (void)setGenderWithSex: (BOOL) sex
{
    if ([[UserManager sharedInstance] sex]) {
        self.genderTextField.text = @"female";
        self.gender = @"F";
        [self.genderPickerView selectRow:1 inComponent:0 animated:NO];
    }else
    {
        self.genderTextField.text = @"male";
        self.gender = @"M";
        [self.genderPickerView selectRow:0 inComponent:0 animated:NO];
    }
}

- (void)birthdayDatePickerChanged:(id)sender
{
    [self setBirthdayData];
}

- (void)resetLabelsColors
{
    self.emailLabel.textColor = [DBSignupViewController labelNormalColor];
    self.passwordLabel.textColor = [DBSignupViewController labelNormalColor];
    self.birthdayLabel.textColor = [DBSignupViewController labelNormalColor];
    self.genderLabel.textColor = [DBSignupViewController labelNormalColor];
    self.phoneLabel.textColor = [DBSignupViewController labelNormalColor];
}

+ (UIColor *)labelNormalColor
{
    return [UIColor colorWithRed:0.016 green:0.216 blue:0.286 alpha:1.000];
}

+ (UIColor *)labelSelectedColor
{
    return [UIColor colorWithRed:0.114 green:0.600 blue:0.737 alpha:1.000];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    [self checkSpecialFields:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[DBSignupViewController labelSelectedColor]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger tag = [textField tag];
    if (tag == BIRTHDAY_FIELD_TAG || tag == GENDER_FIELD_TAG) {
        return NO;
    }else if (tag == EMAIL_FIELD_TAG)
    {
        NSCharacterSet *unacceptedInput = nil;
        if ([[textField.text componentsSeparatedByString:@"@"] count] > 1) {
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-"]] invertedSet];
        } else {
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".!#$%&'*+-/=?^_`{|}~@"]] invertedSet];
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    
    return YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) validateUserName:(NSString * ) username
{
    NSString *usernameRegex = USERNAME_PATTERN;
    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    return [usernamePredicate evaluateWithObject:username];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}


#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = row == 0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];        
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 32)];
    genderLabel.text = [row == 0 ? NSLocalizedString(@"male", @"") : NSLocalizedString(@"female", @"") uppercaseString];
    genderLabel.textAlignment = UITextAlignmentLeft;
    genderLabel.backgroundColor = [UIColor clearColor];
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)] ;
    [rowView insertSubview:imageView atIndex:0];
    [rowView insertSubview:genderLabel atIndex:1];
    return rowView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setGenderData];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    changeAvatar = YES;
	[picker dismissModalViewControllerAnimated:YES];
	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
	[self.photoButton setImage:self.photo forState:UIControlStateNormal];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) loadInfo
{
    self.nameTextField.text = [[UserManager sharedInstance] displayName];
    self.lastNameTextField.text = [[UserManager sharedInstance] username];
    self.passwordTextField.text = [[[UserManager sharedInstance] password] substringToIndex:8];
    self.emailTextField.text = [[UserManager sharedInstance] email];
    [self setGenderWithSex:[[UserManager sharedInstance] sex]];
    self.phoneTextField.text = [[[UserManager sharedInstance] phone] isEqual:[NSNull null]]?@"": [[UserManager sharedInstance] phone];
    [self setBirthdayWithDate:   [[UserManager sharedInstance] birthday]];
    [self.birthdayDatePicker setDate:[[UserManager sharedInstance] birthday] animated:NO];
   
    NSString *strURL = [[UserManager sharedInstance] imgAvata];
    if (strURL == (id)[NSNull null]) {
       strURL = @"";
    }
    if (strURL != (id)[NSNull null] && strURL.length != 0) {
//        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
//        UIImage *photo = [UIImage imageWithData:dataImage];
        
        [self.imvAvatar setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:nil];
        
    }else{
        
    }

    
}
- (void)saveInfoWithAvatar: (NSString *)avatar usage: (NSString *)usage completion:(void (^)(BOOL success, NSError *error))completionBlock {
    NSDictionary *dictParams = [self dictionaryWithURL:avatar andUsage:usage];
    [[NKApiClient shareInstace] postPath:@"register.php" parameters:dictParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"STATUS = %i", operation.response.statusCode);
            id jsonObject = [[JSONDecoder decoder] objectWithData:responseObject];
            NSLog(@"JSON = %@", jsonObject);
            [[UserManager sharedInstance] updateInfoWithDictionary:[jsonObject objectAtIndex:0]];
            
            if (jsonObject) {
                
                if (_viewMode == ProfileViewTypeSignUp) {
                    
                    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
                    [mDict setValue:self.passwordTextField.text forKey:kAccPassword];
                    [mDict setValue:self.lastNameTextField.text forKey:kAccName];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSignUpSuccessful object:mDict];
                }
                completionBlock(YES, nil);
            }else
            {
                [self hudWasHidden:HUD];
                [[TKAlertCenter defaultCenter] performSelector:@selector(postAlertWithMessage:) withObject:@"The username is already exist." afterDelay:0.35];
                completionBlock(NO, nil);
            }
        }else
        {
            completionBlock(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Network Error\nServer is Offline"];
        completionBlock(NO, error);
    }];

}

- (void)saveInfo: (NSData *) imgData WithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error, NSString *urlUpload))completionBlock {

    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    NSDictionary *params = @{
                             @"gift-love[location]" : @"VN",
                             @"gift-love[submitted_by]" : @"foly",
                             @"gift-love[comments]" : @"No"
                             };
    
    NSURLRequest *postRequest = [[NKApiClient shareInstace] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"upload_image.php"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id formData) {
                                                                     [formData appendPartWithFileData:imgData
                                                                                                 name:@"avatar"
                                                                                             fileName:[NSString stringWithFormat:@"%@.png", lastNameTextField_.text]
                                                                                             mimeType:@"image/png"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CODE = %i", operation.response.statusCode);
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"OBJECT = %@", responseObject);

            NSString *urlImage = [responseObject objectAtIndex:0];
            NSLog(@"URL = %@", urlImage);
            completionBlock(YES, nil, urlImage);
    
            
        } else {
            completionBlock(NO, nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error, nil);
        NSLog(@"ERROR %@", error);
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Network Error\nServer is Offline"];
    }];
    
    [[NKApiClient shareInstace] enqueueHTTPRequestOperation:operation];
};

-(BOOL) checkChangePassword
{
    NSString *newPassword = passwordTextField_.text;
    NSString *hashPassword = [[[UserManager sharedInstance] password] substringToIndex:8];
    
    if (![newPassword isEqualToString:hashPassword]) {
        return YES;
    }else
    {
        return NO;
    }
}

-(NSDictionary *)dictionaryWithURL: (NSString *)urlIMG andUsage: (NSString *) usage
{
    
    NSString *strBirthday = [[FunctionObject sharedInstance] stringFromDate:self.birthday];
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setValue:[self.lastNameTextField.text lowercaseString] forKey:kAccName];
    [mDict setValue:self.nameTextField.text forKey:kAccDisplayName];
    [mDict setValue:self.emailTextField.text forKey:kAccEmail];
    
    if ([self checkChangePassword]) {
        [mDict setValue:self.passwordTextField.text forKey:kAccPassword];
    }else{
        [mDict setValue:[[UserManager sharedInstance] password] forKey:kAccPassword];
    }
  
    [mDict setValue:strBirthday forKey:kAccBirthday];
    [mDict setValue:[NSNumber numberWithInt:([self.gender isEqualToString:@"M"]?0:1)] forKey:kAccGender];
    [mDict setValue:self.phoneTextField.text forKey:kAccPhone];
    
    if (urlIMG) {
        [mDict setValue:urlIMG forKey:kaccAvata];
    }else if([usage isEqualToString:@"update_info"])
    {
        [mDict setValue:[[UserManager sharedInstance] imgAvata] forKey:kaccAvata];
    }
    
    [mDict setValue:usage forKey:@"usage"];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                          self.lastNameTextField.text, kAccName,
//                          self.nameTextField.text, kAccDisplayName,
//                          self.emailTextField.text, kAccEmail,
//                          self.passwordTextField.text, kAccPassword,
//                          strBirthday, kAccBirthday,
//                          [NSNumber numberWithInt:([self.gender isEqualToString:@"male"]?1:0)], kAccGender,
//                          self.phoneTextField.text, kAccPhone,
//                          nil];
    return mDict;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate method

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}


@end
