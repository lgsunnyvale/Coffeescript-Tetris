class Tetris
    
    constructor: (@width, @height) ->
        @array         = this.array_factory()
        @mid           = Math.floor @width/2
        @wedge         = [@mid, @mid+@width, @mid+@width-1, @mid+@width+1]
        @square        = [@mid, @mid+1, @mid+@width, @mid+@width+1]
        @stick         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+2]
        @spear         = [@mid, @mid+@width, @mid+2*@width, @mid+3*@width]
        @twist         = [@mid, @mid+@width, @mid+@width+1, @mid+@width+1+@width]
        @tetris_block  = [@wedge, @square, @stick, @twist,@spear]
        @current_rotation_code = 0
        @current_block_type = this.block_type_factory()
        @current_block = this.current_block_factory()
        @dead_block = []
        
    reset: ->
        @array = this.array_factory
        @current_rotation_code = 0
        @current_block_type = this.block_type_factory()
        @current_block = this.current_block_factory()
        @dead_block = []
    
    get_array: ->
        return @array
    
    get_deadblock: ->
        # return @dead_block # to be used when finalized. Now I will use the following for quick debug
        @dead_block = (i for item,i in @array when item==2)
        return @dead_block
    
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
            
    scan_killable_lines: ->
        result=[]
        s=0
        for i in [0...@height]
            for j in [i*@width...(i+1)*@width]
                # if @array[j]==2
                if j in this.get_deadblock()
                    s+=2
            if s==2*@width
                result.push(i)
                # console.log result
            s=0
        return result
    
    kill_lines: (lines) ->
        for i in lines
            for j in [i*@width...(i+1)*@width]
                @array[j]=0
                @dead_block.splice(index, 1) for index, value of @dead_block when value == j
                # console.log @dead_block
            for k in [i*@width-1..0] by -1
                for item,index in @dead_block
                    if item==k 
                        @dead_block[index]+=@width 
                        @array[k]=0
                        @array[k+@width]=2
    
    block_move_down:  ->
        @current_block = ((item + this.width) for item in @current_block)

    block_move_left:  ->
        unless this.touch_left_wall()
            @current_block = ((item - 1) for item in @current_block)
        # console.log(item) for item in @current_block

    block_move_right: ->
        unless this.touch_right_wall()
            @current_block = ((item + 1) for item in @current_block)
    
    rotate: ->
        @current_rotation_code = (@current_rotation_code + 1) % 4
        switch @current_block_type
            when 0 then this.wedge_rotate()
            when 1 then this.square_rotate()
            when 2 then this.stick_rotate()
            when 3 then this.twist_rotate()
            when 4 then this.spear_rotate()
            else console.log "error in find block type"
            
    wedge_rotate: ->
        switch @current_rotation_code
            when 1
                if this.touch_bottom()
                    @current_rotation_code-=1
                    return
                else
                    @current_block[2] = @current_block[1] + @width
            when 2
                if 2 in (@array[j] for j in (i-1 for i in @current_block[0..2]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[0] = @current_block[1]  - 1
            when 3
                @current_block[3] = @current_block[1] - @width
            when 0
                if 2 in (@array[j] for j in (i+1 for i in @current_block[1..3]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[2] = @current_block[1] + 1
                    [@current_block[0], @current_block[3]] = [@current_block[3], @current_block[0]]
                    [@current_block[2], @current_block[3]] = [@current_block[3], @current_block[2]]
        
    square_rotate: ->
        return
    
    stick_rotate: ->
        switch @current_rotation_code
            when 1
                if this.touch_bottom()
                    @current_rotation_code-=1
                    return
                else
                    @current_block[3] = @current_block[0] + 1
                    @current_block[2] = @current_block[1] + @width
            when 2
                if 2 in (@array[j] for j in (i-1 for i in @current_block[0..2]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[2] = @current_block[0] - 1
                    @current_block[3] = @current_block[2] - 1
            when 3
                if 2 in (@array[j] for j in (i+1 for i in @current_block[0..3]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[0] + 1
                    @current_block[2] = @current_block[1] - @width
                    @current_block[3] = @current_block[2] - @width
            when 0
                if this.touch_bottom() or 2 in (@array[j] for j in (i+1 for i in @current_block[0..3]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[0] + @width
                    @current_block[2] = @current_block[1] + 1
                    @current_block[3] = @current_block[2] + 1
    
    twist_rotate: ->
        switch @current_rotation_code
            when 1
                if 2 in (@array[j] for j in (i+@width for i in @current_block[0..1]))
                    @current_rotation_code-=1
                    return
                else     
                    @current_block[3] = @current_block[1] + @width
                    @current_block[0] = @current_block[3] - 1
            when 2
                @current_block[0] = @current_block[1] - @width
                @current_block[3] = @current_block[2] + @width
            when 3
                if 2 in (@array[j] for j in (i+@width for i in @current_block[0..1]))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[3] = @current_block[1] + @width
                    @current_block[0] = @current_block[3] - 1
            when 0
                @current_block[0] = @current_block[1] - @width
                @current_block[3] = @current_block[2] + @width
    
    spear_rotate: ->
        switch @current_rotation_code
            when 1
                if (2 in (@array[j] for j in (i+1 for i in @current_block[0..3]))) or (2 in (@array[j] for j in (i-1 for i in @current_block[0..3])))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[2] - 1
                    @current_block[0] = @current_block[1] - 1
                    @current_block[3] = @current_block[2] + 1
            when 2    
                if this.touch_bottom()
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[2] - @width
                    @current_block[0] = @current_block[1] - @width
                    @current_block[3] = @current_block[2] + @width
            when 3
                if (2 in (@array[j] for j in (i+1 for i in @current_block[0..3]))) or (2 in (@array[j] for j in (i-1 for i in @current_block[0..3])))
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[2] - 1
                    @current_block[0] = @current_block[1] - 1
                    @current_block[3] = @current_block[2] + 1
            when 0
                if this.touch_bottom()
                    @current_rotation_code-=1
                    return
                else
                    @current_block[1] = @current_block[2] - @width
                    @current_block[0] = @current_block[1] - @width
                    @current_block[3] = @current_block[2] + @width
        
    show_block: ->
        for item in this.current_block
            this.array[item] = 1

    touch_left_wall: ->
        # also find if touch any deadblocks to the left. quick and dirty fix. need rework.
        for item in @current_block
            if ((item % @width) == 0 || @array[item-1]==2)
                return true
        return false;
        
    touch_right_wall: ->
        # also find if touch any deadblocks to the left. quick and dirty fix. need rework.
        for item in @current_block
            if (item % @width == (@width-1) || @array[item+1]==2)
                return true
        return false

    touch_bottom: ->
        for item in @current_block
            if item >= (@width * (@height - 1))
                return true
        return false

    solidify: ->
        for item in this.current_block
            @dead_block.push item

    generate_another_block: ->
        @current_block_type = this.block_type_factory()
        @current_block = this.current_block_factory()
        if this.touch_dead_block()
            alert("game over!")
            return false
        else
            @current_rotation_code=0
            return true

    clear_current_block: ->
        for item in @current_block
            @array[item]=0
        @current_block=[]

    touch_dead_block: ->
        for item in @current_block
            if @array[item + @width] == 2
                return true
        return false
    
$ ->

    t = new Tetris(10,20)

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

    down = ->
        
        if t.touch_bottom() or t.touch_dead_block()
            t.solidify()
            t.clear_current_block()
            unless t.generate_another_block()
                t.reset()
            else
                t.clean()
        else
            t.clean()
            t.block_move_down()

        t.kill_lines(t.scan_killable_lines())
        t.show_block()
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
            
    rotate = ->
        t.clean()
        t.rotate()
        t.show_block()
        refresh()
    
    pause_status = 0
    $(document).keydown (e) ->
        switch e.which
            when 37 then left()
            when 38 then rotate()
            when 39 then right()
            when 40 then down()
            when 32 
                if pause_status==0
                    pause()
                else
                    resume()
                pause_status = ~pause_status
            else return; 
        e.preventDefault()
    
    t.clean()
    t.show_block()
    refresh()
    
    timer = setInterval down, 1000
    
    pause = ->
        clearInterval timer
    
    resume = ->
        timer = setInterval down, 1000

# start testing now
    test "scan lines to kill", ->
        tt = new Tetris 3,3
        tt.array = [0,0,0,0,0,0,2,2,2]
        r = tt.scan_killable_lines()
        deepEqual r, [2], "should find the last line is full to be killed"
        tt.array = [0,0,0,2,2,2,2,2,2]
        r = tt.scan_killable_lines()
        deepEqual r, [1,2], "should find the last two lines is full to be killed"
        
    test "find deadblocks", ->
        tt = new Tetris 3,3
        tt.array = [0,0,0,0,0,0,2,2,2]
        d = tt.get_deadblock()
        deepEqual d, [6,7,8], "should find the last elements are deadblocks"
        tt.array = [0,0,0,2,2,2,2,2,2]
        d = tt.get_deadblock()
        deepEqual d, [3,4,5,6,7,8], "should find the last elements are deadblocks"
        
    test "kill lines", ->
        tt = new Tetris 3,3
        tt.array = [0,0,0,0,0,0,2,2,2]
        deepEqual [2], tt.scan_killable_lines(), "should scan right"
        tt.kill_lines(tt.scan_killable_lines())
        deepEqual tt.get_array(), (0 for i in [0...9]), "should kill lines"
        tt.array = [0,2,0,2,2,2,2,2,2]
        tt.kill_lines(tt.scan_killable_lines())
        deepEqual tt.get_array(), (0 for i in [0...6]).concat([0,2,0]), "should kill the last two lines"

    #         test "kill a row", ->
    #             tt = new Tetris 3,3
    #             tt.array = [0,0,0,0,0,0,2,2,2]
    #             tt.kill_row(2)
    #             equal tt.array[6], 0, "the row is zero-ed after killing a row"
    #             equal tt.array[7], 0, "the row is zero-ed after killing a row"
    #             equal tt.array[8], 0, "the row is zero-ed after killing a row"
    #             equal tt.array.length, 9, "make sure length is right"
    #         
    #         test "drop a unit block", ->
    #             tt = new Tetris 3,3
    #             tt.array = [0,0,0,0,0,0,2,2,2]
    #             tt.drop_block_unit 5
    #             equal tt.array[5], 0, "the block unit should have dropped below"
    #             equal tt.array[6], 2, "the row is zero-ed after killing a row"
    #             equal tt.array[7], 2, "the row is zero-ed after killing a row"
    #             equal tt.array[8], 2, "the block unit should appear here"
    #         
    #         test "find out all deadblocks above", ->
    #             tt = new Tetris 3,3
    #             tt.array = [0,0,0,2,2,0,0,0,0]
    #             equal tt.dead_blocks_above(2)[0], 3, "it should return the index of all deadblocks above"
    #             equal tt.dead_blocks_above(2)[1], 4, "it should return the index of all deadblocks above"
    #             equal tt.dead_blocks_above(2).length, 2, "it should return the index of all deadblocks above"
    #         
    #         test "drop all deadblocks above", ->
    #             tt = new Tetris 3,3
    #             tt.array = [0,0,0,2,2,0,0,0,0]
    #             equal tt.drop_all_dead_blocks_above_row(2), true, "it should successfully drop all dead blocks above"
    #             equal tt.array[6], 2, "it should revise the array property"
    #             equal tt.array[7], 2, "it should revise the array property"
    #             equal tt.array[8], 0, "it should revise the array property"
    #             equal tt.array.length, 9, "it should revise the array property"
    #     