class @MoveAnimation
  constructor: (@pieces, @axis, @angle_to_turn, @turn_time, animate) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

    unless animate
      this.finish()

  update: (now) ->
    return if @finished

    if now > @start_time + @turn_time
      this.finish()
    else
      this.rotate(now)

  finish: ->
    return if @finished

    this.rotate(@start_time + @turn_time)
    @finished = true

  rotate: (to_time) ->
    change = (to_time - @last_time) * @angle_to_turn / @turn_time
    @last_time = to_time

    for piece in @pieces
      this._rotateAroundWorldAxis(piece, change)

  # Rotate an object around an arbitrary axis in world space #adapted from http://stackoverflow.com/questions/11119753/how-to-rotate-a-object-on-axis-world-three-js
  _rotateAroundWorldAxis: (object, radians) ->
    rotWorldMatrix = new THREE.Matrix4()
    rotWorldMatrix.makeRotationAxis(@axis, radians)
    rotWorldMatrix.multiply(object.matrix) # pre-multiply

    object.matrix = rotWorldMatrix
    object.rotation.setFromRotationMatrix(object.matrix)
