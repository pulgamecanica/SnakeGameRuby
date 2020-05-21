require 'ruby2d'

set background: 'black'
set fps_cap: 25


set width: 1200, height: 800

SQUARE_SIZE = 20
GRID_WIDTH = Window.width / SQUARE_SIZE
GRID_HEIGHT = Window.height / SQUARE_SIZE

class Snake
  attr_writer :direction

  def initialize
    @positions = [[2, 0], [2, 1], [2, 2], [2 ,3], [2 ,4], [2 ,5], [2 ,6], [2 ,7], [2 ,8], [2 ,9], [2 ,10]]
    @direction = 'down'
    @growing = false
    @a = 'gray'
  end

  def random_color
  	range = rand(7)
  	case range
	  	when 1
	  		@a = 'green'
	  	when 2
	  		@a = 'blue'	
	  	when 3
	  		@a = 'red'
	  	when 4
	  		@a = 'gray'
	  		
	  	when 5
	  		@a = 'white'
	  	when 6
	  		@a = 'yellow'
	  	when 7
	  		@a = 'brown'		
	  end  	
  end

  def draw
    @positions.each do |position|
      Square.new(x: position[0] * SQUARE_SIZE, y: position[1] * SQUARE_SIZE, size: SQUARE_SIZE - 1, color: random_color)
    end
  end

  def grow
    @growing = true
  end

  def move
    if !@growing
      @positions.shift
    end

    @positions.push(next_position)
    @growing = false
  end

  def can_change_direction_to?(new_direction)
    case @direction
    when 'up' then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end
  end

  def x
    head[0]
  end

  def y
    head[1]
  end

  def next_position
    if @direction == 'down'
      new_coords(head[0], head[1] + 1)
    elsif @direction == 'up'
      new_coords(head[0], head[1] - 1)
    elsif @direction == 'left'
      new_coords(head[0] - 1, head[1])
    elsif @direction == 'right'
      new_coords(head[0] + 1, head[1])
    end
  end

  def hit_itself?
    @positions.uniq.length != @positions.length
  end

  private

  def new_coords(x, y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end

  def head
    @positions.last
  end
end

class Game
  def initialize
    @ball_x = 10
    @ball_y = 10
    @ball_x2 = 20
    @ball_y2 = 20
    @score = 0
    @finished = false
    random_color(rand(8))
  end

  def hard_mode(hard)
    @hard = hard
  end
  def random_color(a)
  	case a
	  	when 1
	  		@a = 'green'
	  	when 2
	  		@a = 'blue'	
	  	when 3
	  		@a = 'red'
	  	when 4
	  		@a = 'gray'
	  		
	  	when 5
	  		@a = 'white'
	  	when 6
	  		@a = 'yellow'
	  	when 7
	  		@a = 'brown'	
      when 8
        @a = 'pink'  	
	  end
  	
  end
  def draw
    Square.new(x: @ball_x * SQUARE_SIZE, y: @ball_y * SQUARE_SIZE, size: SQUARE_SIZE, color: @a)
    Text.new(text_message, color: 'green', x: 10, y: 10, size: 25, z: 1)
  end

 def draw2
    if @hard == true
      Square.new(x: @ball_x2 * SQUARE_SIZE, y: @ball_y2 * SQUARE_SIZE, size: SQUARE_SIZE, color: @a)
      Text.new(text_message, color: 'green', x: 10, y: 10, size: 25, z: 1)
    end
  end

  def snake_hit_ball?(x, y)
    @ball_x == x && @ball_y == y
  end

  def record_hit
    @score += 1
    @ball_x = rand(Window.width / SQUARE_SIZE)
    @ball_y = rand(Window.height / SQUARE_SIZE)
    @ball_x2 = rand(Window.width / SQUARE_SIZE)
    @ball_y2 = rand(Window.height / SQUARE_SIZE)
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  private

  def text_message
    if finished?
      "Game over, Your Score was #{@score}. Press 'R' to restart. Press 'H' for hard mode "
    elsif @score>3
      "There you go, you are the BOSS #{@score}"
    elsif @score>4
      "You are on FIRE!!!!!! you have collected #{@score}"
    else 
      "There you go, you have collected: #{@score} sqares"
    end
  end
end

snake = Snake.new
game = Game.new

update do
  clear

  unless game.finished?
    snake.move
  end

  snake.draw
  game.draw
  game.draw2

  if game.snake_hit_ball?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end

  if snake.hit_itself?
    game.finish
  end
end

on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key)
    if snake.can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  end

  if game.finished? && event.key == 'r'
    snake = Snake.new
    game = Game.new 
    game.hard_mode(false)
  end
  if game.finished? && event.key == 'h'
    snake = Snake.new
    game = Game.new
    game.hard_mode(true)
  end
end

show