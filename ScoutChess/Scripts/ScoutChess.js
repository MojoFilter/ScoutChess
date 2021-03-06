﻿// Generated by IcedCoffeeScript 108.0.9
(function() {
  var assets, boardMargin, coX, coY, gameHeight, gameWidth, images, pieceMoveDuration, r;

  gameHeight = 1080;

  gameWidth = 2000;

  boardMargin = 36;

  coX = 63.625;

  coY = 64.375;

  pieceMoveDuration = 1000;

  r = function(f) {
    return '/Assets/' + f;
  };

  images = {
    board: r('chessboard.jpg')
  };

  assets = {
    audio: {
      music: [r('fetty-wap-trap-queen-instrumental.mp3')]
    },
    images: [images.board],
    sprites: {
      '/Assets/Indicators.png': {
        tile: 64,
        tileh: 64,
        map: {
          indicator_light: [0, 0],
          indicator_dark: [1, 0]
        }
      },
      '/Assets/Pieces.png': {
        tile: 64,
        tileh: 64,
        map: {
          pawn_brown: [0, 0],
          rook_brown: [1, 0],
          knight_brown: [2, 0],
          bishop_brown: [3, 0],
          king_brown: [4, 0],
          queen_brown: [5, 0],
          pawn_pink: [0, 1],
          rook_pink: [1, 1],
          knight_pink: [2, 1],
          bishop_pink: [3, 1],
          king_pink: [4, 1],
          queen_pink: [5, 1]
        }
      }
    }
  };

  $(function() {
    Crafty.init(gameWidth, gameHeight, $('#game')[0]);
    return Crafty.scene('loading');
  });

  Crafty.scene('loading', function() {
    return Crafty.load(assets, function() {
      Crafty.e('2D, DOM, Text').text('LOADING....');
      return Crafty.scene('main');
    });
  }, function(e) {
    return {};
  }, function(e) {
    debugger;
  });

  Crafty.scene('main', function() {
    var calcX, calcY, game, indicators, p, _i, _len, _ref;
    calcX = function(col) {
      return boardMargin + (coX * col);
    };
    calcY = function(row) {
      return boardMargin + (coY * row);
    };
    Crafty.c('Unit', {
      unit: function(column, row) {
        this.requires('2D');
        this.x = calcX(column);
        this.y = calcY(row);
        this.h = 64;
        this.w = 64;
        return this;
      }
    });
    Crafty.c('Piece', {
      piece: function(p) {
        var self;
        self = this;
        this.requires('2D, DOM, Tween, Mouse, Unit');
        this.requires("" + p.rank + "_" + p.team);
        this.unit(p.column(), p.row());
        this.z = 500;
        p.column.subscribe(function(col) {
          return self.tween({
            x: calcX(col)
          }, pieceMoveDuration);
        });
        p.row.subscribe(function(row) {
          return self.tween({
            y: calcY(row)
          }, pieceMoveDuration);
        });
        this.bind('Click', function(ev) {
          return game.selectPiece(p);
        });
        return this;
      }
    });
    Crafty.c('Indicator', {
      indicator: function(column, row, color) {
        this.requires('2D, DOM, Unit');
        this.unit(column, row);
        this.z = 400;
        this.alpha = 0.75;
        return this;
      }
    });
    Crafty.c('Active', {
      active: function(column, row) {
        this.requires('Indicator, indicator_dark');
        this.indicator(column, row, 'red');
        return this;
      }
    });
    Crafty.c('Option', {
      option: function(column, row) {
        this.requires('Indicator, indicator_light, Mouse');
        this.indicator(column, row, 'green');
        this.bind('Click', function(ev) {
          return game.move(column, row);
        });
        return this;
      }
    });
    Crafty.e('2D, DOM, Image').image(images.board);
    game = new ScoutChess();
    _ref = game.pieces;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      p = _ref[_i];
      Crafty.e('Piece').piece(p);
    }
    indicators = [];
    return game.selectedPiece.subscribe(function(p) {
      var i, m, _j, _k, _len1, _len2, _ref1, _results;
      for (_j = 0, _len1 = indicators.length; _j < _len1; _j++) {
        i = indicators[_j];
        i.destroy();
      }
      indicators = [];
      if (p != null) {
        indicators.push(Crafty.e('Active').active(p.column(), p.row()));
        _ref1 = game.getMoves(p);
        _results = [];
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          m = _ref1[_k];
          _results.push(indicators.push(Crafty.e('Option').option(m.column, m.row)));
        }
        return _results;
      }
    });
  });

}).call(this);
