require 'rubygems'
require 'gosu'

%w{word text timer}.each do |lib|
  require File.dirname(__FILE__) + '/' + lib
end

class TrainingWheels < Gosu::Window
  def initialize
    super 800, 600, false
    @font       = Gosu::Font.new self, Gosu::default_font_name, 40
    @small_font = Gosu::Font.new self, Gosu::default_font_name, 25
    @rocket     = Gosu::Sample.new self, 'sounds/bottlerocket.wav'
    @ohno       = Gosu::Sample.new self, 'sounds/oh_no.wav'
    @word       = Word.new self
    @timer      = Timer.new self, 15, @font
    @scoreboard = Text.new self, 0, @font, :bottom, :left
  end

  def objects
    @objects ||= [
      Text.new(self, 'Training Wheels!', @font, :top, :left),
      Text.new(self, 'Space for correct answers; Esc to exit', @small_font, :bottom, :right),
      @word,
      @scoreboard,
      @timer
    ]
  end

  def update
    wrong if @timer.value == 0
  end

  def draw
    objects.each {|str| str.draw}
  end

  def button_down(id)
    case id
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbRight
      wrong
    when Gosu::Button::KbSpace
      correct
    end
  end

  def wrong
    @timer.reset
    @ohno.play
    @scoreboard.value = @scoreboard.value - 50
    @word.wrong
  end

  def correct
    @timer.reset
    @rocket.play
    @scoreboard.value = @scoreboard.value + (10 * @timer.value)
    @word.correct
  end
end

window = TrainingWheels.new
window.show

