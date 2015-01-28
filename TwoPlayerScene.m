//
//  OnePlayerScene.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "TwoPlayerScene.h"
#import "ShogiBoard.h"
#import "MainMenuScene.h"

@implementation TwoPlayerScene


-(id) initWithSize:(CGSize)size {
    if ([super initWithSize:size]) {
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"gameSceneBlank"];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];
        
        SKShapeNode* boardArea = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .965, self.frame.size.width * .97)];
        boardArea.name = @"BoardArea";
        boardArea.position = CGPointMake(self.frame.size.width/2 + 1, self.frame.size.height/2);
        boardArea.lineWidth = 0;
        boardArea.zPosition++;
        [self addChild:boardArea];
        
        SKShapeNode* profilePlayer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .095, self.frame.size.width * .0946)];
        profilePlayer.name = @"PlayerProfilePic";
        profilePlayer.position = CGPointMake(self.frame.size.width * .068, self.frame.size.height * .073);
        profilePlayer.zPosition++;
        profilePlayer.lineWidth = 0;
        [self addChild:profilePlayer];
        
        SKShapeNode* profileEnemy = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .095, self.frame.size.width * .0946)];
        profileEnemy.name = @"PlayerProfilePic";
        profileEnemy.position = CGPointMake(self.frame.size.width * .933, self.frame.size.height * .9245);
        profileEnemy.zPosition++;
        profileEnemy.lineWidth = 0;
        [self addChild:profileEnemy];
        
        SKSpriteNode* mainMenuButton = [SKSpriteNode spriteNodeWithImageNamed:@"mainMenuButton"];
        mainMenuButton.name = @"MainMenuButton";
        mainMenuButton.position = CGPointMake(mainMenuButton.size.width/2 + 4, mainMenuButton.size.height/2 + 3);
        mainMenuButton.zPosition++;
        [self addChild:mainMenuButton];
        
        //Shogi Board allocation from custom class
        self.board = [[ShogiBoard alloc] init];
        
        self.gridBoxWidth = (boardArea.frame.size.width + 12) / 9;
        self.selectedPiece = [[NSMutableArray alloc] init];
        self.possibleMovesShowing = false;
        self.gameMenuShowing = false;
        
        // update the board
        [self updateBoard];
        
    }
    return self;
}

// go through each piece, remove from parent, and reallocate correct piece for self.board reresentation
// may want to make this more efficient in the futute by only changing pieces which have moves. But I digress...
-(void) updateBoard {
    SKShapeNode* boardArea = (SKShapeNode*)[self childNodeWithName:@"BoardArea"];
    
    // delete all children!! muahahahahahahahaha >:)
    [boardArea removeAllChildren];
    
    // RECREATE the CHILDREN!!
    for (int i=0; i<9; ++i){
        for (int j=0; j<9; ++j){
            SKSpriteNode* piece = [self.board nodeFromPiece:[self.board pieceAtRowI:i ColumnJ:j]];
            
            if (piece != nil) {
                piece.position = CGPointMake(-self.gridBoxWidth * (4-j), self.gridBoxWidth * (4-i));
                piece.name = @"piece";
                [boardArea addChild:piece];
            }
            
        }
    }
}

-(void)showPossibleMovesForPiece:(SKSpriteNode *)piece {
    // do stuff
}

-(void) showPossibleMovesFromArray:(NSArray* )moves {
    SKShapeNode* boardArea = (SKShapeNode*)[self childNodeWithName:@"BoardArea"];
    for (NSArray* move in moves) {
        int i = [[move objectAtIndex:0] intValue];
        int j = [[move objectAtIndex:1] intValue];
        SKSpriteNode* possibleMove = [SKSpriteNode spriteNodeWithImageNamed:@"possibleMove"];
        possibleMove.position = CGPointMake(-self.gridBoxWidth * (4-j), self.gridBoxWidth * (4-i));
        possibleMove.name = @"move";
        
        [boardArea addChild:possibleMove];
    }
}

-(NSArray* ) indicesForNode:(SKNode *)node {
    int j = 4 + (node.position.x / self.gridBoxWidth);
    int i = 4 - (node.position.y / self.gridBoxWidth);
    
    NSArray* indices = @[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ];
    
    return indices;
}

-(void) showGameMenu {
    self.gameMenuShowing = true;
    SKSpriteNode* gameMenuPopup = [SKSpriteNode spriteNodeWithImageNamed:@"gameMenuPopup"];
    gameMenuPopup.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    gameMenuPopup.zPosition += 10;
    gameMenuPopup.name = @"GameMenuPopup";
    [self addChild:gameMenuPopup];
    
    SKShapeNode* mainMenuButton = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(gameMenuPopup.size.width * .90, gameMenuPopup.size.height * .19)];
    mainMenuButton.lineWidth = 0;
    mainMenuButton.position = CGPointMake(0, gameMenuPopup.size.height * .12);
    mainMenuButton.name = @"MainMenuGOTO";
    [gameMenuPopup addChild:mainMenuButton];
    
    SKShapeNode* restartButton = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(gameMenuPopup.size.width * .90, gameMenuPopup.size.height * .19)];
    restartButton.lineWidth = 0;
    restartButton.position = CGPointMake(0, gameMenuPopup.size.height * -.115);
    restartButton.name = @"RestartGame";
    [gameMenuPopup addChild:restartButton];
    
    SKShapeNode* gameMenuBack = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(gameMenuPopup.size.width * .90, gameMenuPopup.size.height * .19)];
    gameMenuBack.lineWidth = 0;
    gameMenuBack.position = CGPointMake(0, gameMenuPopup.size.height * -.35);
    gameMenuBack.name = @"GameMenuBack";
    [gameMenuPopup addChild:gameMenuBack];
    
}

-(void) hideGameMenu {
    self.gameMenuShowing = false;
    SKNode* gameMenuPopup = [self childNodeWithName:@"GameMenuPopup"];
    [gameMenuPopup removeAllChildren];
    [gameMenuPopup removeFromParent];
}

-(void) showPromotionOptionForPiece:(int)piece {
    self.promotedPieceOptionShowing = true;
    SKSpriteNode* promotionsPane = [SKSpriteNode spriteNodeWithImageNamed:@"promotionOptions"];
    promotionsPane.position = CGPointMake(self.size.width/2, self.size.height/2);
    promotionsPane.zPosition += 10;
    promotionsPane.name = @"PromotionsPane";
    [self addChild:promotionsPane];
    
    SKSpriteNode* promoted = [self.board nodeFromPiece:(piece<0 ? piece - 10 : piece + 10)];
    promoted.position = CGPointMake(promotionsPane.size.width * .22, 0);
    promoted.name = @"promotion";
    promoted.zPosition++;
    [promotionsPane addChild:promoted];
    
    SKSpriteNode* notPromoted = [self.board nodeFromPiece:piece];
    notPromoted.position = CGPointMake(promotionsPane.size.width * -.22, 0);
    notPromoted.name = @"noPromotion";
    notPromoted.zPosition++;
    [promotionsPane addChild:notPromoted];
}

-(void) hidePromotionOptionPiece{
    self.promotedPieceOptionShowing = false;
    SKNode* promotionsPane = [self childNodeWithName:@"PromotionsPane"];
    [promotionsPane removeAllChildren];
    [promotionsPane removeFromParent];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKNode* nodeTouched = [self nodeAtPoint: [touch previousLocationInNode:self] ];
    NSString* name = nodeTouched.name;
    if (!([name isEqualToString:@"promotion"] || [name isEqualToString:@"noPromotion"]) && self.promotedPieceOptionShowing) {
        printf("IN THERE");
        // hide possible moves
        SKNode* grid = [self childNodeWithName:@"BoardArea"];
        [grid removeAllChildren];
        self.selectedPiece = nil;
        self.possibleMovesShowing = false;
        [self hidePromotionOptionPiece];
    
        //update board
        [self updateBoard];
    } else if (([name isEqualToString:@"promotion"] || [name isEqualToString:@"noPromotion"]) && self.promotedPieceOptionShowing) {
        printf("IN HERE");
        bool promotion = [name isEqualToString:@"promotion"] ? true : false;
        // move selected piece from indices value to new value on data representation
        [self.board movePieceAtRow:[[self.selectedPiece objectAtIndex:0] intValue] column:[[self.selectedPiece objectAtIndex:1] intValue] toRow:[[self.indices objectAtIndex:0] intValue] toColumn:[[self.indices objectAtIndex:1] intValue] promote:promotion];
        
        SKNode* grid = [self childNodeWithName:@"BoardArea"];
        [grid removeAllChildren];
        self.selectedPiece = nil;
        self.possibleMovesShowing = false;
        self.indices = nil;
        [self hidePromotionOptionPiece];
        
        //update board
        [self updateBoard];
        
    } else if ([name isEqualToString:@"piece"] && !_possibleMovesShowing && !_gameMenuShowing){
        // if touched a piece and possible moves are not showing select the piece and show possible moves
        self.selectedPiece = [[self indicesForNode:nodeTouched] mutableCopy];
        NSNumber* row = [self.selectedPiece objectAtIndex:0];
        NSNumber* col = [self.selectedPiece objectAtIndex:1];
        NSArray* moves = [self.board possibleMovesOfPieceAtRow:row column:col];
        
        self.possibleMovesShowing = true;
        [self showPossibleMovesFromArray:moves];
        
    } else if ([name isEqualToString:@"move"] && _possibleMovesShowing && !_gameMenuShowing) {
        // if touched possible move then move the piece and update board
        int piece = [self.board pieceAtRowI:[[self.selectedPiece objectAtIndex:0] intValue] ColumnJ:[[self.selectedPiece objectAtIndex:1] intValue]];
        self.indices = [[self indicesForNode:nodeTouched] mutableCopy];
        
        int indicesI = [[self.indices objectAtIndex:0] intValue];
        int pieceI = [[self.selectedPiece objectAtIndex:0] intValue];
        printf("Piece column- %d | move column- %d\n", pieceI, indicesI);
        // show promotion options if applicable
        if (piece > 0 && piece < GOLD && indicesI<3 && pieceI>2){
            [self showPromotionOptionForPiece:piece];
        } else if (piece > 0 && piece < GOLD && pieceI<3 && indicesI>2) {
            [self showPromotionOptionForPiece:piece];
        } else if (piece < 0 && piece > -GOLD && indicesI>5 && pieceI<6) {
            [self showPromotionOptionForPiece:piece];
        } else if (piece < 0 && piece > -GOLD && pieceI>5 && indicesI<6) {
            [self showPromotionOptionForPiece:piece];
        } else {
            // move selected piece from indices value to new value on data representation
            [self.board movePieceAtRow:[[self.selectedPiece objectAtIndex:0] intValue] column:[[self.selectedPiece objectAtIndex:1] intValue] toRow:[[self.indices objectAtIndex:0] intValue] toColumn:[[self.indices objectAtIndex:1] intValue] promote:false];
            
            SKNode* grid = [self childNodeWithName:@"BoardArea"];
            [grid removeAllChildren];
            self.selectedPiece = nil;
            self.possibleMovesShowing = false;
            self.indices = nil;
            
            //update board
            [self updateBoard];
        }
    } else if ( ![name isEqualToString:@"move"] && _possibleMovesShowing && !_gameMenuShowing) {
        // if possible moves showing and something besides a move selected, hide/delete all possible move circles
        // hide possible moves and set boolean to false
        self.possibleMovesShowing = false;
        SKNode* grid = [self childNodeWithName:@"BoardArea"];
        for (SKNode* move in grid.children) {
            if ([move.name isEqualToString:@"move"]){
                [move removeFromParent];
            }
        }
        self.selectedPiece = nil;
        
    // go through game menu possibilities
    } else if ([name isEqualToString:@"MainMenuButton"] && !_gameMenuShowing) {
        [self showGameMenu];
    } else if ([name isEqualToString:@"GameMenuBack"]) {
        [self hideGameMenu];
    } else if ([name isEqualToString:@"MainMenuGOTO"]) {
        MainMenuScene* scene = [[MainMenuScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    } else if ([name isEqualToString:@"RestartGame"]) {
        TwoPlayerScene* scene = [[TwoPlayerScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
        
    // else nothing touched
    } else {
        printf("\nTouched away from possible nodes...\n");
        if (self.selectedPiece != nil) {
            self.selectedPiece = nil;
        }
    }
    
}


@end
