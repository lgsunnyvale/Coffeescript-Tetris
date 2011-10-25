class Tetris
    constructor: (@width, @height) ->
        @array         = (0 for item in [0...@width*@height])
        @mid           = Math.floor @width/2
        @wedge         = [@mid, @mid+@width, @mid+@width-1, @mid+@width+1]
        @square        = [@mid, @mid+1, @mid+@width, @mid+@width+1]
        @stick         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+2]
        @twist         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+1+@width]
        @tetris_block  = [@wedge, @square, @stick, @twist]

    current_block_index: -> Math.floor(Math.random() * @tetris_block.length)

    to_s: ->
        array_item for array_item in this.array

    block_move_down: (block) ->
        (item + this.height) for item in block

    block_move_left: (block) ->
        (item-1) for item in block

    block_move_right: (block) ->
        (item+1) for item in block

    current_block: ->
        @tetris_block[this.current_block_index()]

    show_block: ->
        for item in this.current_block()
            this.array[item] = 1

$ ->

    t = new Tetris(5,10)
    t.show_block()
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
        $("body").append "<table>#{table}</table>"

    $("#debug").val "hey"
    $("#config_btn").click(refresh)
