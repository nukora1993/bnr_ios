//
//  QuizViewController.m
//  Quiz
//
//  Created by nuko on 2020/6/6.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()
@property (nonatomic) int currentQuestionIndex;

@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@end

@implementation QuizViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        // init data of questions and anseers
        self.questions=@[@"From what is coganc made?",
                         @"What is 7+7",
                         @"What is the capital of Vermont?"];
        
        self.answers=@[@"Grapes",
                       @"14",
                       @"Montpelier"];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark button-action
- (IBAction)showQuestion:(id)sender{
    self.currentQuestionIndex++;
    
    if(self.currentQuestionIndex==[self.questions count]){
        self.currentQuestionIndex=0;
    }
    
    NSString *question = self.questions[self.currentQuestionIndex];
    
    self.questionLabel.text=question;
    
    self.answerLabel.text=@"???";
    
}

- (IBAction)showAnswer:(id)sender{
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    self.answerLabel.text = answer;
}

@end
