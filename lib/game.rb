# tracks frames and handles bonus logic
class Game
  attr_reader :frames, :score_board

  def initialize(args = {})
    @frame_class = args[:frame_class] || Frame
    @score_board = args[:score_board] || ScoreBoard
    @current_frame = frame_class.new
    @frames = []
  end

  def add_roll(pins)
    raise GameOverError if game_over?

    current_frame.add_roll(pins)
    add_bonus(pins) unless frames.empty?
    finish_frame if current_frame.over?
    score
  end

  def score
    score_board.total_score(frames)
  end

  private

  attr_reader :frame_class
  attr_accessor :current_frame

  def finish_frame
    frames << current_frame
    return if game_over?

    self.current_frame = frame_class.new
    current_frame.final if frames.count == 9
  end

  def game_over?
    frames.count == 10
  end

  def add_bonus(pins)
    frames.each { |frame| frame.add_bonus(pins) unless frame.bonus_count.zero? }
  end
end
