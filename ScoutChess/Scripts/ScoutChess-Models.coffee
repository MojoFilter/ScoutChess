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