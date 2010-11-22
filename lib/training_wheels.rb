require 'rubygems'
require 'gosu'

%w{word text timer}.each do |lib|
  require File.dirname(__FILE__) + '/' + lib
end

class TrainingWheels < Gosu::Window
  def initialize
    puts "Starting"
    super 800, 600, false
    @font             = Gosu::Font.new self, Gosu::default_font_name, 40
    @small_font       = Gosu::Font.new self, Gosu::default_font_name, 25
    @rocket           = Gosu::Sample.new self, 'sounds/bottlerocket.wav'
    @ohno             = Gosu::Sample.new self, 'sounds/oh_no.wav'
    @music            = Gosu::Sample.new self, 'sounds/guitar-2229.wav'
    @word             = Word.new self
    @timer            = Timer.new self, 15, @font
    @scoreboard       = Text.new self, 0, @font, :bottom, :left
    @review_text      = Text.new(self, 'Review', @font, :top, :center, 0xffff0000)
    @background_image = Gosu::Image.new self, "images/background.png", true
    @correct_image    = Gosu::Image.new self, "images/correct.png", true
    @wrong_image      = Gosu::Image.new self, "images/wrong.png", true
    @pointer          = Gosu::Image.new self, "images/pointer.png", true

    @timer.width      = 50
    @review           = false
    @music.play 0.2, 1, true
  end

  def objects
    @objects ||= [
      Text.new(self, 'Training Wheels!', @font, :top, :left),
      Text.new(self, 'Space for correct answers Esc to exit', @small_font, :bottom, :right),
      @word,
      @scoreboard
    ]
  end

  def update
    if @timer.value < 0 && !@review # put us into review mode to look over the word
      @word.play
      @review = true
    elsif @timer.value <= -5        # now mark it as wrong and go to the next word
      wrong
      @review = false
    end
  end

  def draw
    objects.each {|str| str.draw}

    @background_image.draw 0,0,0
    icon_heights = @correct_image.height + @wrong_image.height
    @correct_image.draw self.width-@correct_image.width-10, (self.height - icon_heights - 75)/2, 1
    @wrong_image.draw self.width-@correct_image.width, (self.height - icon_heights + 225)/2, 1
    @pointer.draw self.mouse_x, self.mouse_y, 1

    if @review
      @review_text.draw
    else
      @timer.draw
      (21..26).each do |r|
        draw_circle @timer.horizon+15, @timer.vert+17, r
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbRight
      wrong unless @review
    when Gosu::Button::KbSpace
      correct unless @review
    when Gosu::Button::MsLeft
      correct #if within @correct_image
      wrong if within @wrong_image
    end
  end

  def within image
    # we need an image object that knows how to draw itself.
  end

  def wrong
    @timer.reset
    #@ohno.play
    @scoreboard.value = @scoreboard.value - 50
    @word.wrong
  end

  def correct
    @timer.reset
    @rocket.play
    @scoreboard.value = @scoreboard.value + (10 * @timer.value)
    @word.correct
  end


  ######################### Drawing Algorithms ###########################
  def draw_circle x_center, y_center, radius
    r2 = radius * radius

    x = 1
    y = (Math.sqrt(r2 - 1) + 0.5)
    while (x < y) do
      draw_point(x_center + x, y_center - y) if @timer.value > 15
      draw_point(x_center + y, y_center - x) if @timer.value > 13
      draw_point(x_center + y, y_center + x) if @timer.value > 11
      draw_point(x_center + x, y_center + y) if @timer.value > 9
      draw_point(x_center - x, y_center + y) if @timer.value > 7
      draw_point(x_center - y, y_center + x) if @timer.value > 5
      draw_point(x_center - y, y_center - x) if @timer.value > 3
      draw_point(x_center - x, y_center - y) if @timer.value > 1
      x += 1
      y = (Math.sqrt(r2 - x*x) + 0.5)
    end

    draw_point(x_center, y_center + radius)
    draw_point(x_center, y_center - radius)
    draw_point(x_center + radius, y_center)
    draw_point(x_center - radius, y_center)
    if (x == y)
      draw_point(x_center + x, y_center + y)
      draw_point(x_center + x, y_center - y)
      draw_point(x_center - x, y_center + y)
      draw_point(x_center - x, y_center - y)
    end
  end

  def draw_point x, y, color = 0xff000000
    draw_line x, y, color, x+0, y+1, color
  end
end

module Math
  def self.abs x
    x < 0 ? x * -1 : x
  end
end
