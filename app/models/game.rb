class Game < ApplicationRecord
  # Валидации
  validates :board, length: { is: 9 }
  validates :current_player, inclusion: { in: %w[X O] }
  validates :status, inclusion: { in: %w[in_progress won draw] }

  # Перед валидацией инициализируем поле и статус
  before_validation :initialize_game

  # Инициализация новой игры
  def initialize_game
    self.board = ' ' * 9 if board.blank?       # пустое поле из 9 пробелов
    self.current_player = 'X' if current_player.blank?
    self.status = 'in_progress' if status.blank?
  end

  # Метод для совершения хода
  # position - индекс клетки от 0 до 8
  def make_move(position)
    return false unless valid_move?(position)
    return false unless status == 'in_progress'

    new_board = board.dup
    new_board[position] = current_player

    # Обновляем поле и меняем игрока
    self.board = new_board
    self.status = calculate_status(new_board)
    self.current_player = current_player == 'X' ? 'O' : 'X'

    save
  end

  # Проверка, что ход валиден
  def valid_move?(position)
    position.between?(0, 8) && board[position] == ' ' && status == 'in_progress'
  end

  private

  # Логика проверки победы или ничьи
  def calculate_status(board)
    winning_positions = [
      [0,1,2], [3,4,5], [6,7,8], # строки
      [0,3,6], [1,4,7], [2,5,8], # столбцы
      [0,4,8], [2,4,6]           # диагонали
    ]

    winning_positions.each do |line|
      chars = line.map { |pos| board[pos] }
      if chars.uniq.size == 1 && chars.first != ' '
        return 'won'
      end
    end

    # Если нет пустых клеток — ничья
    return 'draw' unless board.include?(' ')

    'in_progress'
  end
end
