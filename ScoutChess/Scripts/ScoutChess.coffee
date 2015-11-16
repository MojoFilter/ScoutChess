# CoffeeScript
gameHeight = 1080
gameWidth = 2000
boardMargin = 36
coX = 63.625
coY = 64.375
pieceMoveDuration = 1000 #ms

r = (f) -> '/Assets/' + f

images =
    board: r 'chessboard.jpg'
    
assets =
    audio:
        music: [r 'fetty-wap-trap-queen-instrumental.mp3']
    images: [images.board]
    sprites:
        '/Assets/Pieces.png':
            tile: 64
            tileh: 64
            map:
                pawn_brown:   [0,0]
                rook_brown:   [1,0]
                knight_brown: [2,0]
                bishop_brown: [3,0]
                king_brown:   [4,0]
                queen_brown:  [5,0]
                
                pawn_pink:   [0,1]
                rook_pink:   [1,1]
                knight_pink: [2,1]
                bishop_pink: [3,1]
                king_pink:   [4,1]
                queen_pink:  [5,1]

$ () -> 
    Crafty.init(gameWidth, gameHeight, $('#game')[0])
    Crafty.scene 'loading'
    
    
Crafty.scene('loading', 
    () -> Crafty.load(assets, ->
            Crafty.e('2D, DOM, Text')
                  .text 'LOADING....'
              
            Crafty.scene 'main')
    (e) -> {}
    (e) -> debugger)
    
Crafty.scene 'main', ()->
    Crafty.c 'Piece',
        piece: (p) ->
            self = this
            @requires '2D, DOM, Tween, Mouse'
            @requires "#{p.rank}_#{p.team}"
            
            calcX = (col) -> boardMargin + (coX * p.column())
            calcY = (row) -> boardMargin + (coY * p.row())
            @x = calcX p.column()
            @y = calcY p.row()
            p.column.subscribe (col) -> self.tween {x: calcX col}, pieceMoveDuration
            p.row.subscribe (row) -> self.tween {y: calcY row}, pieceMoveDuration
            
            @bind 'Click', (ev) ->
                if game.turn is p.team
                    alert "Move that #{p.rank}"
            
    Crafty.e '2D, DOM, Image'
          .image images.board
    
    #Crafty.audio.play('music', -1)
    
    game = new ScoutChess()
    Crafty.e('Piece').piece p for p in game.pieces
