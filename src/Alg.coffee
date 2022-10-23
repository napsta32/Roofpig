#= require Move
#= require CompositeMove
#= require AlgAnimation

class Alg
  constructor: (@move_codes, @world3d, @algdisplay, @speed, @dom, @startsolved) ->
    @playing = false
    @next = 0
    @moves = []
    this.refresh_moves()
    this._update_dom('init', 'first time')

  refresh_moves: ->
    temp_playing = @playing
    @playing = false
    pos = 0
    for code in @move_codes.split(' ')
      if code.length > 0
        if pos < @moves.length
          @moves[pos] = this._make_move(code)
        else
          @moves.push(this._make_move(code))
        pos = pos + 1
    @playing = temp_playing

  update_moves: (new_moves) ->
    this.stop()
    if @startsolved
      this.to_start()
    else
      this.to_end()
      @next = 0
    @move_codes = new_moves
    @moves = []
    this.refresh_moves()
    this._update_dom('init', 'first time')
    this.mix() unless @startsolved

  set_start_solved: (startsolved) ->
    this.stop()
    if @startsolved
      this.to_start()
    else
      this.to_end()
      @next = 0
    this._update_dom('init', 'first time')
    @startsolved = startsolved
    this.mix() unless @startsolved

  next_move: ->
    unless this.at_end()
      @next += 1
      if this.at_end() then @playing = false
      this._update_dom('next_move')
      @moves[@next-1]

  prev_move: ->
    unless this.at_start()
      @next -= 1
      this._update_dom('prev_move')
      @moves[@next]

  play: ->
    @playing = true
    this._update_dom('play')
    new AlgAnimation(this)

  stop: ->
    @playing = false
    this._update_dom('stop')

  to_end: ->
    until this.at_end()
      this.next_move().do()

  to_start: ->
    until this.at_start()
      this.prev_move().undo()

  at_start: ->
    @next == 0

  at_end: ->
    @next == @moves.length

  mix: ->
    @next =  @moves.length
    until this.at_start()
      this.prev_move().mix()

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')

  display_text: ->
    active = past = []
    future = []
    for move, i in @moves
      if @next == i then active = future
      text = move.display_text(@algdisplay)
      if text
        active.push(text)
    { past: past.join(' '), future: future.join(' ')}

  turn_codes = {'-2': ['Z', '2'], '-1': ["'", ''], 1: ['', "'"], 2: ['2', 'Z']}
  _make_move: (code) ->
    if code.indexOf('+') > -1
      new CompositeMove(code, @world3d, @speed)

    else if code[0] in ['x', 'y', 'z']
      [t1, t2] = turn_codes[Move.parse_turns(code.substring(1))]
      moves = switch code[0]
        when 'x' then "R#{t1}+M#{t2}+L#{t2}"
        when 'y' then "U#{t1}+E#{t2}+D#{t2}"
        when 'z' then "F#{t1}+S#{t1}+B#{t2}"
      new CompositeMove(moves, @world3d, @speed, code)

    else
      last_char_index = 2 if (code[1] == 'w' && code[0] in ['U', 'D', 'L', 'R', 'F', 'B'])
      last_char_index = 1 if (code[0] in ['u', 'd', 'l', 'r', 'f', 'b'])
      if last_char_index
        [t1, t2] = turn_codes[Move.parse_turns(code.substring(last_char_index))]
        moves = switch code[0].toUpperCase()
          when 'R' then "R#{t1}+M#{t2}"
          when 'L' then "L#{t1}+M#{t1}"
          when 'U' then "U#{t1}+E#{t2}"
          when 'D' then "D#{t1}+E#{t1}"
          when 'F' then "F#{t1}+S#{t1}"
          when 'B' then "B#{t1}+S#{t2}"
        new CompositeMove(moves, @world3d, @speed, code)

      else
        new Move(code, @world3d, @speed)

  unhand: ->
    pov = new Pov()
    result = []
    for move in @moves
      result.push(pov.hand_to_cube(move.as_brdflu()))
      pov.track(move)
    result.join(' ').replace(/[ ]+/g, ' ').replace(/^ +| +$/g, '')

  @pov_from: (move_codes) ->
    new Pov(new Alg(move_codes).moves)

  _update_dom: (event_name, time = 'later') ->
    if @dom && @moves.length > 0
      if time == 'first time'
        @dom.init_alg_text(this.display_text().future)

      @dom.alg_changed(@playing, this.at_start(), this.at_end(), this._count_text(), this.display_text(), event_name)

  _count_text: ->
    total = current = 0
    for move, i in @moves
      count = move.count(@algdisplay.rotations)
      current += count if @next > i
      total += count
    "#{current}/#{total}"