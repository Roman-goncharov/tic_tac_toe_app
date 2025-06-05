class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  # GET /games
  # Можно показывать список игр или последнюю игру
  def index
    @games = Game.all.order(created_at: :desc)
  end

  # GET /games/:id
  # Показываем конкретную игру
  def show
  end

  # POST /games
  # Создаём новую игру
  def create
    @game = Game.new
    if @game.save
      redirect_to @game
    else
      @games = Game.all.order(created_at: :desc)
      flash.now[:alert] = "Не удалось создать игру: #{@game.errors.full_messages.join(', ')}"
      render :index
    end
  end


  # PATCH/PUT /games/:id
  # Совершаем ход
  def update
    position = params[:position].to_i
    if @game.make_move(position)
      redirect_to @game
    else
      flash[:alert] = "Неверный ход или игра уже завершена"
      render :show
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
