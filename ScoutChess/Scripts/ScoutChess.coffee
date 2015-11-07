# CoffeeScript
gameHeight = 1080
gameWidth = 2000

r = (f) -> '/Resources/' + f

images =
    board: r 'chessboard.jpg'
    
assets =
    images: [images.board]

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
    Crafty.e '2D, DOM, Image'
          .image images.board