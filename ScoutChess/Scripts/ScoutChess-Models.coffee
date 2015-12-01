﻿# CoffeeScript
player1 = 'brown'
player2 = 'pink'

roles =
    pawn: 'pawn'
    rook: 'rook'
    knight: 'knight'
    bishop: 'bishop'
    queen: 'queen'
    king: 'king'

window.ScoutChess = () ->
    @pieces = []
    @turn = player1
    @selectedPiece = ko.observable()
    
    @selectPiece = (p) -> @selectedPiece p if p.team is @turn
    
    @isOccupied = (column, row) -> @pieces.some (p) -> p.column() is column and p.row() is row
    
    onBoard = (column, row) -> column >= 0 and column < 8 and row >= 0 and row < 8
    
    @getMoves = (p) ->
        moves = []
        switch p.rank
            when roles.pawn
                dir = if p.team is player1 then 1 else -1
                moves.push
                    column: p.column() + dir
                    row: p.row()
                if not p.initiated?
                    moves.push
                        column: p.column() + dir * 2
                        row: p.row()
            when roles.rook
                #N
                r = p.row() - 1
                until r < 0 or @isOccupied p.column(), r
                    moves.push
                        column: p.column()
                        row: r
                    r--
                #S
                r = p.row() + 1
                until r > 7 or @isOccupied p.column(), r
                    moves.push
                        column: p.column()
                        row: r
                    r++
                #E
                c = p.column() + 1
                until c > 7 or @isOccupied c, p.row()
                    moves.push
                        column: c
                        row: p.row()
                    c++
                #W
                c = p.column() - 1
                until c < 0 or @isOccupied c, p.row()
                    moves.push
                        column: c
                        row: p.row()
                    c--    
            when roles.knight
                ks = [[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1],[-2,-1],[-2,1]]
                for dir in ks
                    c = dir[0] + p.column()
                    r = dir[1] + p.row()
                    if onBoard(c, r) and not @isOccupied c, r
                        moves.push
                            column: c
                            row: r
            when roles.bishop
                self = this
                bish = (cd, rd) ->                   
                    c = p.column() + cd
                    r = p.row() + rd
                    until not onBoard(c, r) or self.isOccupied(c, r)
                        moves.push
                            column: c
                            row: r
                        c += cd
                        r += rd
                bish -1, -1
                bish -1, 1
                bish 1, -1
                bish 1, 1
                
         moves
         
    @move = (column, row) ->
        if @selectedPiece()?
            @selectedPiece().column column
            @selectedPiece().row row
            @selectedPiece().initiated = true
            @selectedPiece null
            @turn = if @turn is player1 then player2 else player1
            
    createTeamPieces = (team, isRightPlayer) ->
        s = (fromLeft) -> if isRightPlayer then 7 - fromLeft else fromLeft
        pieces = (new Piece(team, roles.pawn, s(1), r) for r in [0...8])
        b = (rank, row) -> pieces.push new Piece team, rank, s(0), row
        b roles.rook, 0
        b roles.knight, 1
        b roles.bishop, 2
        b roles.queen, 3
        b roles.king, 4
        b roles.bishop, 5
        b roles.knight, 6
        b roles.rook, 7
        pieces
        
    
    @pieces.push piece for piece in createTeamPieces player1
    @pieces.push piece for piece in createTeamPieces player2, true
    
    this
    

Piece = (team, rank, column, row) ->
    @team = team
    @rank = rank
    @column = ko.observable(column)
    @row = ko.observable(row)
    this