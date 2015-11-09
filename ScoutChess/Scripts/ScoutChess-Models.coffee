# CoffeeScript
window.ScoutChess = () ->
    @pieces = []
    
    createTeamPieces = (team, isRightPlayer) ->
        s = (fromLeft) -> if isRightPlayer then 7 - fromLeft else fromLeft
        pieces = (new Piece(team, 'pawn', s(1), r) for r in [0...8])
        b = (rank, row) -> pieces.push new Piece team, rank, s(0), row
        b 'rook', 0
        b 'knight', 1
        b 'bishop', 2
        b 'queen', 3
        b 'king', 4
        b 'bishop', 5
        b 'knight', 6
        b 'rook', 7
        pieces
        
    
    @pieces.push piece for piece in createTeamPieces 'brown'
    @pieces.push piece for piece in createTeamPieces 'pink', true
    
    this

Piece = (team, rank, column, row) ->
    @team = team
    @rank = rank
    @column = ko.observable(column)
    @row = ko.observable(row)
    this