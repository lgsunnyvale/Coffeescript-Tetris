class Tetris
    constructor: (@width, @height) ->
        @array         = (0 for item in [0...@width*@height])
        @mid           = Math.floor @width/2
        @wedge         = [@mid, @mid+@width, @mid+@width-1, @mid+@width+1]
        @square        = [@mid, @mid+1, @mid+@width, @mid+@width+1]
        @stick         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+2]
        @twist         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+1+@width]
        @tetris_block  = [@wedge, @square, @stick, @twist]
        @current_block_type = this.block_type_factory()
        @current_block = this.current_block_factory()

    block_type_factory: ->
        Math.floor(Math.random() * @tetris_block.length)

    current_block_factory: ->
        this.tetris_block[this.current_block_type]

    to_s: ->
        array_item for array_item in this.array

    clean: ->
        @array = (0 for item in [0...@width*@height])

    block_move_down:  ->
        @current_block = ((item + this.width) for item in @current_block)

    block_move_left: (block) ->
        @current_block = ((item - 1) for item in @current_block)

    block_move_right: (block) ->
        @current_block = ((item + 1) for item in @current_block)

    show_block: ->
        for item in this.current_block
            this.array[item] = 1
$ ->

    t = new Tetris(5,10)

    refresh = ->
       row=""
       table=""
       for item in [0...t.height]
           table = table + "<tr>"
           for jtem in [0...t.width]
               n = jtem+item*t.width
               row = row + "<td class=#{if t.array[n]==1 then 'block' else 'cell'} id=#{n}>#{n}</td>"
           table = table + row + "</tr>"
           row=""
       $("#frame").html "<table>#{table}</table>"

    t.show_block()
    refresh()

    drop = ->
        t.clean()
        t.block_move_down()
        t.show_block()
        refresh()

    left = ->
        t.clean()
        t.block_move_left()
        t.show_block()
        refresh()

    right = ->
        t.clean()
        t.block_move_right()
        t.show_block()
        refresh()

    $("#config_btn").click drop
