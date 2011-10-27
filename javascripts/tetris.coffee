class Tetris
    constructor: (@width, @height) ->
        @array         = this.array_factory()
        @mid           = Math.floor @width/2
        @wedge         = [@mid, @mid+@width, @mid+@width-1, @mid+@width+1]
        @square        = [@mid, @mid+1, @mid+@width, @mid+@width+1]
        @stick         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+2]
        @twist         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+1+@width]
        @tetris_block  = [@wedge, @square, @stick, @twist]
        @current_block_type = this.block_type_factory()
        @current_block = this.current_block_factory()
        @dead_block = [@width*(@height-1) ... @width*@height]

    array_factory: ->
        @array = (0 for item in [0...@width*@height])

    block_type_factory: ->
        Math.floor(Math.random() * @tetris_block.length)

    current_block_factory: ->
        this.tetris_block[this.current_block_type]

    to_s: ->
        array_item for array_item in this.array

    clean: ->
        this.array_factory()
        for item in @dead_block
            @array[item]=2

    block_move_down:  ->
        @current_block = ((item + this.width) for item in @current_block)

    block_move_left: (block) ->
        @current_block = ((item - 1) for item in @current_block)

    block_move_right: (block) ->
        @current_block = ((item + 1) for item in @current_block)

    show_block: ->
        for item in this.current_block
            this.array[item] = 1

    touch_left_wall: ->
        for item in @current_block
            if ((item % @width) == 1)
                result = true
            else
                result = false
        result

    touch_right_wall: ->
        for item in @current_block
            if (item % @width == (@width-1))
                result = true
            else
                result = false
        result

    touch_bottom: ->
        for item in @current_block
            if item >= (@width * (@height - 1))
                result = true
            else
                result = false
        result

    solidify: ->
        for item in this.current_block
            @array[item] = 2

    touch_dead_block: ->
        for item in @current_block
            if @array[item + @height] == 2
                result = true
            else
                result = false
        result

    any_row_to_kill: ->
        result = new Array
        for row in [0...@height]
            row_sum = 0
            for col in [0...@width]
                row_sum = row_sum + @array[row*@width+col]
            if row_sum == 2*@width
                result.push(row)
        result

    kill_row: (n) ->
        for item in [n*@width ... (n+1)*@width]
            @array[item]=0

$ ->

    t = new Tetris(5,5)

    refresh = ->
       row=""
       table=""
       for item in [0...t.height]
           table = table + "<tr>"
           for jtem in [0...t.width]
               n = jtem+item*t.width
               if t.array[n]==1
                   cell_css = 'block'
               else if t.array[n] == 2
                   cell_css = 'dead_block'
               else
                   cell_css = 'cell'
               row = row + "<td class=#{cell_css} id=#{n}>#{n}</td>"
           table = table + row + "</tr>"
           row=""
       $("#frame").html "<table>#{table}</table>"

    t.clean()
    t.show_block()
    refresh()

    down = ->
        unless t.touch_bottom()
            unless t.touch_dead_block()
                t.clean()
                t.block_move_down()
                t.show_block()
                refresh()
            else
                t.clean()
                t.solidify()
                refresh()

    left = ->
        unless t.touch_left_wall()
            t.clean()
            t.block_move_left()
            t.show_block()
            refresh()

    right = ->
        unless t.touch_right_wall()
            t.clean()
            t.block_move_right()
            t.show_block()
            refresh()

    $("#down_btn").click down
    $("#left_btn").click left
    $("#right_btn").click right

    test "kill a row", ->
        tt = new Tetris 3,3
        tt.array = [0,0,0,0,0,0,2,2,2]
        tt.kill_row(2)
        equal tt.array[6], 0, "the row is zero-ed after killing a row"
        equal tt.array[7], 0, "the row is zero-ed after killing a row"
        equal tt.array[8], 0, "the row is zero-ed after killing a row"
        equal tt.array.length, 9, "make sure length is right"