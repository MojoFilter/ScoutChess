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
    
    calcX = (col) -> boardMargin + (coX * col)
    calcY = (row) -> boardMargin + (coY * row)
    
    Crafty.c 'Unit',
        unit: (column, row) ->
            @requires '2D'
            @x = calcX column
            @y = calcY row
            @h = 64
            @w = 64
            this
            
    Crafty.c 'Piece',
        piece: (p) ->
            self = this
            @requires '2D, DOM, Tween, Mouse, Unit'
            @requires "#{p.rank}_#{p.team}"
            @unit p.column(), p.row()
            @z = 500
            p.column.subscribe (col) -> self.tween {x: calcX col}, pieceMoveDuration
            p.row.subscribe (row) -> self.tween {y: calcY row}, pieceMoveDuration
            
            @bind 'Click', (ev) -> game.selectPiece p
            this
            
    Crafty.c 'Indicator',
        indicator: (column, row, color) ->
            @requires '2D, DOM, Color, Unit'
            @unit column, row
            @z = 400
            @color color
            @alpha = 0.75
            this
            
    Crafty.c 'Active',
        active: (column, row) ->
            @requires 'Indicator'
            @indicator column, row, 'red'
            this
            
    Crafty.c 'Option',
        option: (column, row) ->
            @requires 'Indicator, Mouse'
            @indicator column, row, 'green'
            @bind 'Click', (ev) -> game.move column, row
            this
            
    Crafty.e '2D, DOM, Image'
          .image images.board
    
    #Crafty.audio.play('music', -1)
    
    game = new ScoutChess()
    Crafty.e('Piece').piece p for p in game.pieces
    
    indicators = []
    game.selectedPiece.subscribe (p) ->
        i.destroy() for i in indicators
        indicators = []
        if p?
            indicators.push Crafty.e('Active').active p.column(), p.row()
            indicators.push(Crafty.e('Option').option m.column, m.row) for m in game.getMoves p
