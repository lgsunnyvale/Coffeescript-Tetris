(function() {
  var Tetris;
  Tetris = (function() {
    function Tetris(width, height) {
      var item;
      this.width = width;
      this.height = height;
      this.array = (function() {
        var _ref, _results;
        _results = [];
        for (item = 0, _ref = this.width * this.height; 0 <= _ref ? item < _ref : item > _ref; 0 <= _ref ? item++ : item--) {
          _results.push(0);
        }
        return _results;
      }).call(this);
      this.mid = Math.floor(this.width / 2);
      this.wedge = [this.mid, this.mid + this.width, this.mid + this.width - 1, this.mid + this.width + 1];
      this.square = [this.mid, this.mid + 1, this.mid + this.width, this.mid + this.width + 1];
      this.stick = [this.mid, this.mid + this.width, this.mid + this.width + 1, this.mid + this.width + 2];
      this.twist = [this.mid, this.mid + this.width, this.mid + this.width + 1, this.mid + this.width + 1 + this.width];
      this.tetris_block = [this.wedge, this.square, this.stick, this.twist];
    }
    Tetris.prototype.current_block_index = function() {
      return Math.floor(Math.random() * this.tetris_block.length);
    };
    Tetris.prototype.to_s = function() {
      var array_item, _i, _len, _ref, _results;
      _ref = this.array;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        array_item = _ref[_i];
        _results.push(array_item);
      }
      return _results;
    };
    Tetris.prototype.block_move_down = function(block) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = block.length; _i < _len; _i++) {
        item = block[_i];
        _results.push(item + this.height);
      }
      return _results;
    };
    Tetris.prototype.block_move_left = function(block) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = block.length; _i < _len; _i++) {
        item = block[_i];
        _results.push(item - 1);
      }
      return _results;
    };
    Tetris.prototype.block_move_right = function(block) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = block.length; _i < _len; _i++) {
        item = block[_i];
        _results.push(item + 1);
      }
      return _results;
    };
    Tetris.prototype.current_block = function() {
      return this.tetris_block[this.current_block_index()];
    };
    Tetris.prototype.show_block = function() {
      var item, _i, _len, _ref, _results;
      _ref = this.current_block();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(this.array[item] = 1);
      }
      return _results;
    };
    return Tetris;
  })();
  $(function() {
    var refresh, t;
    t = new Tetris(5, 10);
    t.show_block();
    refresh = function() {
      var item, jtem, n, row, table, _ref, _ref2;
      row = "";
      table = "";
      for (item = 0, _ref = t.height; 0 <= _ref ? item < _ref : item > _ref; 0 <= _ref ? item++ : item--) {
        table = table + "<tr>";
        for (jtem = 0, _ref2 = t.width; 0 <= _ref2 ? jtem < _ref2 : jtem > _ref2; 0 <= _ref2 ? jtem++ : jtem--) {
          n = jtem + item * t.width;
          row = row + ("<td class=" + (t.array[n] === 1 ? 'block' : 'cell') + " id=" + n + ">" + n + "</td>");
        }
        table = table + row + "</tr>";
        row = "";
      }
      return $("body").append("<table>" + table + "</table>");
    };
    $("#debug").val("hey");
    return $("#config_btn").click(refresh);
  });
}).call(this);
